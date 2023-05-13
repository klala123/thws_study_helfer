import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  User? user;

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  void setUser(User? user) {
    this.user = user;
  }
}
