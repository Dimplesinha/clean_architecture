import 'package:logging/logging.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:workapp/src/data/storage/preference/preference_exports.dart';
import 'package:workapp/src/domain/models/block_unblock_model.dart';
import 'package:workapp/src/domain/models/chat/chat_result_common_model.dart';
import 'dart:async';
import 'package:workapp/src/domain/models/send_message_model.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_screen_cubit.dart';
import 'package:workapp/src/utils/app_utils.dart';

/// Manages SignalR real-time communication for the chat functionality.
///
/// Responsibilities:
/// - Establishes and maintains WebSocket connection with the server
/// - Handles incoming messages and typing status updates
/// - Provides connection status and management
///
class SignalRHelper {
  // Base URL for the SignalR hub
  final String _baseUrl = 'https://workapp-2.azurewebsites.net';

  // Name of the SignalR hub
  final String _hubName = 'messageHub';

  // Reference to the SignalR hub connection
  HubConnection? hubConnection;

  // Flag to prevent concurrent connection attempts
  bool _isConnecting = false;

  // Public getters for connection status and ID
  bool get isConnected => hubConnection?.state == HubConnectionState.Connected;
  bool get isConnecting => _isConnecting;
  String get connectionId => hubConnection?.connectionId ?? '';

  // Callbacks for handling received data
  Function(ChatResultCommonModel)? onMessageReceived; // For individual messages
  Function(ChatResultCommonModel)? onMessageReceivedInListingScreen; // For chat list updates
  Function(ChatResultCommonModel)? onMessageReceivedInHomeScreen; // For home screen updates
  Function(TypingStatusModel)? typingStatus; // For typing indicators
  Function(TypingStatusModel)? typingStatusInListingScreen; // For typing indicators
  Function(ChatResultCommonModel)? markMessageAsRead; // For mark as read
  Function(BlockUnBlockResult)? blockUnBlockUserFromSignalR; // to block the user
  Function(String)? sendConnectionId; // For mark as read
  TypingStatusModel? typingStatusModel;
  // Singleton pattern implementation
  static final SignalRHelper _instance = SignalRHelper._internal();
  SignalRHelper._internal();
  static SignalRHelper get instance => _instance;

  /// Establishes a connection to the SignalR hub
  ///
  /// [userId]: The ID of the connecting user
  /// [callback]: Function to handle connection result (success, result, error)
  Future<void> connect(String userId, void Function(bool success, String? result, dynamic error) callback) async {
    // Prevent duplicate connections
    if (isConnected || _isConnecting) {
      print('Already connected or connecting. Skipping new connection attempt.');
      return;
    }

    try {
      _isConnecting = true;

      // Set up logging configuration
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });

      final transportProtLogger = Logger('SignalR - transport');
      final hubProtLogger = Logger('SignalR - hub');
      var user = await PreferenceHelper.instance.getUserData();
      String token = user.result?.token ?? '';

      // Configure HTTP connection options
      final httpOptions = HttpConnectionOptions(
        logger: transportProtLogger,
        requestTimeout: 300000,
        headers: MessageHeaders()
          ..setHeaderValue('Cross-Origin-Resource-Policy', '*'),
      );


      // Build and configure the hub connection
      hubConnection = HubConnectionBuilder()
          .withUrl('$_baseUrl/$_hubName?access_token=$token')
          .withAutomaticReconnect()
          .configureLogging(hubProtLogger)
          .withHubProtocol(JsonHubProtocol())
          .build();
      hubConnection?.serverTimeoutInMilliseconds = 120000; // 2 minutes
      hubConnection?.keepAliveIntervalInMilliseconds = 15000; // 15 seconds

      // Register event handlers
      _registerHubMethods();
      hubConnection?.onclose(_onClose);
      hubConnection?.onreconnecting(_reconnecting);
      hubConnection?.onreconnected(_reconnected);

      if (hubConnection == null) {
        return;
      }

      // Skip if already connected
      if (hubConnection!.state == HubConnectionState.Connected) {
        return;
      }

      // Start the connection
      await hubConnection?.start();

      if (!isConnected) {
        throw Exception('Failed to establish connection');
      }


      // Notify success with connection ID if available
      if (connectionId.isNotEmpty) {
        callback(true, connectionId, null);
      } else {
        callback(true, null, null);
      }
    } catch (e) {
      print('Connection error: $e');
      callback(false, null, e);
      rethrow;
    } finally {
      _isConnecting = false;
    }
  }

  /// Starts a periodic keep-alive ping to maintain connection
  ///
  /// [connection]: The HubConnection instance to keep alive
  void startKeepAlive(HubConnection connection) {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (connection.state == HubConnectionState.Connected) {
        connection.invoke('Ping').catchError((error) {
          print('Keep-alive failed: $error');
        });
      } else {
        timer.cancel(); // Stop timer if connection is lost
      }
    });
  }

  /// Registers handlers for hub methods called by the server
  void _registerHubMethods() {
    // Handle successful connection
    hubConnection?.on('OnConnectedAsync', (args) {
      print('Connection Established: $args');
      if (args != null && args.isNotEmpty) {
        final data = args[0] as Map<String, dynamic>;
        print('Connection Established:');
        print('  Connection ID: ${data['connectionId']}');
        print('  Message: ${data['message']}');
        print('  Timestamp: ${data['timestamp']}');
      }
    });

    // Handle incoming messages
    hubConnection?.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final jsonData = arguments[0] as Map<String, dynamic>;
          final message = ChatResultCommonModel.fromJson(jsonData);

          // Trigger appropriate callbacks with parsed data
          // Access the singleton Cubit
          final currentScreen = ScreenCubit().state;

          if (currentScreen == ActiveScreen.chatScreen) {
            onMessageReceived?.call(message);
          } else if (currentScreen == ActiveScreen.chatListingScreen) {
            onMessageReceivedInListingScreen?.call(message);
            onMessageReceivedInHomeScreen?.call(message);
          } else {
            onMessageReceivedInHomeScreen?.call(message);
          }
        } catch (e) {
          print('Error parsing message: $e');
        }
      }
    });

    // Handle typing status updates
    hubConnection?.on('TypingStatus', (arguments) {
      print('TypingStatus Rec: ${arguments.toString()}');
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final jsonData = arguments[0] as Map<String, dynamic>;
          final typingStatusResult = TypingStatusModel.fromJson(jsonData);

          final currentScreen = ScreenCubit().state;
          typingStatusModel = typingStatusResult;

          // Trigger typing status callback
          if (currentScreen == ActiveScreen.chatScreen) {
            typingStatus?.call(typingStatusResult);
          } else if (currentScreen == ActiveScreen.chatListingScreen) {
            typingStatusInListingScreen?.call(typingStatusResult);
          }

        } catch (e) {
          print('Error parsing message: $e');
        }
      }
    });

    // Handle successful connection
    hubConnection?.on('MarkMessagesAsRead', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final jsonData = arguments[0] as Map<String, dynamic>;
          final markAsReadResult = ChatResultCommonModel.fromJson(jsonData);

          // Trigger typing status callback
          markMessageAsRead?.call(markAsReadResult);
          // onMessageReceivedInHomeScreen?.call(markAsReadResult);
        } catch (e) {
          print('Error parsing message: $e');
        }
      }
    });

    // Handle Blocked User
    hubConnection?.on('BlockUser', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final jsonData = arguments[0] as Map<String, dynamic>;
          final markAsReadResult = BlockUnBlockResult.fromJson(jsonData);

          // Trigger typing status callback
          blockUnBlockUserFromSignalR?.call(markAsReadResult);
        } catch (e) {
          print('Error parsing message: $e');
        }
      }
    });
  }

  /// Invokes the TypingStatus method on the server
  ///
  /// [arg]: Map containing typing status data to send
  Future<void> typingStatusInvoke(TypingStatusModel arg) async {
   print('TypingStatus ==> ${arg.toJson().toString()}');

    await hubConnection?.invoke('TypingStatus', args: [arg]);
  }

  /// Disconnects from the SignalR hub
  Future<void> disconnect() async {
    await hubConnection?.stop();
    _isConnecting = false;
  }

  /// Called when the system is attempting to reconnect.
  /// [error] can optionally contain the reason for disconnection or failure.
  void _reconnecting({Exception? error}) {
    // You can log the error or show a reconnection UI here if needed.
  }

  /// Called when the reconnection is successful.
  /// [connectionId] is the new connection identifier received after reconnection.
  void _reconnected({String? connectionId}) {
    // Send the new connection ID back to the caller or external handler.
    sendConnectionId?.call(connectionId ?? '');
  }

  /// Handles connection closure
  ///
  /// [error]: Optional error that caused the closure
  void _onClose({Exception? error}) {
    _isConnecting = false;
    if (error != null && !isConnected && !_isConnecting) {
      Future.delayed(const Duration(seconds: 5), () {
        connect(AppUtils.loginUserModel?.uuid ?? '', (success, result, error) {
          if (success && result != null && error == null) {
            sendConnectionId?.call(result);
          }
        },);
      });
    }
  }

  final StreamController<int> _unreadMessageCountController = StreamController<int>.broadcast();

  Stream<int> get unreadMessageCountStream => _unreadMessageCountController.stream;

  void updateUnreadMessageCount(int count) {
    _unreadMessageCountController.add(count);
  }

  final StreamController<int> refreshMessageStreamController = StreamController<int>.broadcast();

  Stream<int> get refreshMessageStream => refreshMessageStreamController.stream;

  /// Call this to trigger refresh from anywhere
  void triggerMessageListRefresh() {
    refreshMessageStreamController.add(DateTime.now().millisecondsSinceEpoch);
  }


  void dispose() {
    _unreadMessageCountController.close();
    refreshMessageStreamController.close();
  }
}