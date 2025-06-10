import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workapp/src/domain/domain_exports.dart';
import 'package:workapp/src/presentation/application/app_view.dart';
import 'package:workapp/src/presentation/modules/add_switch_account/add_switch_account_exports.dart';
import 'package:workapp/src/presentation/modules/home/cubit/landing_page_cubit.dart';
import 'package:workapp/src/presentation/modules/message/cubit/message_cubit.dart';
import 'package:workapp/src/presentation/modules/message_chat/cubit/message_chat_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/cubit/my_listing_cubit.dart';
import 'package:workapp/src/presentation/modules/my_listing/repo/my_listing_repo.dart';
import 'package:workapp/src/presentation/style/theme/theme_notifier.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 07/11/23
/// @Message :
/// [AppInitializer]
class AppInitializer {
  static final AppInitializer _singleton = AppInitializer._();

  AppInitializer._();

  static AppInitializer get instance => _singleton;

  /// Trigger App
  Future<void> triggerApp() async {
    /// Enable Console Logger
    ConsoleLogger.instance.enableConsoleLogger();

    /// Initialize and Add Interceptors to ApiClient
    await ApiRepository.instance.initAllServices();

    // Code commented for future reference
    /// Init Firebase Services
   // FirebaseRepository.instance.initAllServices();

    /// Init Api Services
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeNotifier()),

            /// Register All Bloc Providers
            BlocProvider<MessageCubit>(create: (_) => MessageCubit()),
            BlocProvider<MessageChatCubit>(create: (_) => MessageChatCubit()),
            BlocProvider<LandingPageCubit>(create: (_) => LandingPageCubit()),
            BlocProvider<MyListingCubit>(
                create: (_) =>
                    MyListingCubit(myListingRepo: MyListingRepo.instance)),
          ],
          child: const AppView(),
        ),
      );
    });
  }
}
