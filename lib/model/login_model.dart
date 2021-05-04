import 'package:firebase_auth/firebase_auth.dart';

class LoginModel {
  UserCredential credential;
  String errorValue;

  LoginModel(this.credential);

  LoginModel.withError(String errorValue)
      : credential = null,
        errorValue = errorValue;
}
