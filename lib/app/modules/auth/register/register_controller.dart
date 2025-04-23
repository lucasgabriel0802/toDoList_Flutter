import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class RegisterController extends ChangeNotifier {
  final UserService _userService;
  String? errorMessage;
  bool success = false;

  RegisterController({required UserService userService}) : _userService = userService;

  void registerUser({required String email, required String password}) async {
    try {
      errorMessage = null;
      success = false;
      notifyListeners();
      final user = await _userService.register(email, password);
      if (user != null) {
        success = true;
      } else {
        errorMessage = 'User registration failed';
      }
    } on AuthException catch (e) {
      errorMessage = e.message;
    } finally {
      notifyListeners();
    }
  }
}
