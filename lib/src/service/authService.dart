

import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  bool _isLogged = false;

  bool get isLogged => _isLogged;

  set isLogged(bool value){
    _isLogged = value;
    notifyListeners();
  }
}