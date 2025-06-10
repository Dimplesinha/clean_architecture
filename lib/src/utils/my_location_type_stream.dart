import 'dart:async';

class LocationTypeStream {
  static final LocationTypeStream _singleton = LocationTypeStream._internal();

  LocationTypeStream._internal();

  static LocationTypeStream get instance => _singleton;
  // StreamController to manage the stream
  final StreamController<String> _controller = StreamController<String>.broadcast();

  // Exposed Stream to listen to data
  Stream<String> get stream => _controller.stream;

  // Method to add data to the stream
  void addLocationType(String locationType) {
    _controller.sink.add(locationType);
  }

  // Dispose method to close the StreamController
  void dispose() {
    _controller.close();
  }
}
