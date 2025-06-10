/// Created by
/// @AUTHOR : Prakash Software Solutions Pvt Ltd
/// @DATE : 03-10-2024
/// @Message : [SignUpRepo]

class SignUpRepo {
  static final SignUpRepo _singleton = SignUpRepo._internal();

  SignUpRepo._internal();

  static SignUpRepo get instance => _singleton;
}
