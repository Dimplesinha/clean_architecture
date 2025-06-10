import 'package:flutter_bloc/flutter_bloc.dart';

// Define an enum for the screens
enum ActiveScreen {
  homeScreen,
  chatScreen,
  chatListingScreen,
}

class ScreenCubit extends Cubit<ActiveScreen> {
  static final ScreenCubit _instance = ScreenCubit._internal();

  factory ScreenCubit() {
    return _instance;
  }

  ScreenCubit._internal() : super(ActiveScreen.homeScreen);

  void setScreen(ActiveScreen screen) {
    emit(screen);
  }
}