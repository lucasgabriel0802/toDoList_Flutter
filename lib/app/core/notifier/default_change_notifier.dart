import 'package:flutter/material.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  bool _success = false;
  String? _errorMessage;
  bool _loading = false;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isSuccess => _success;

  void showLoading() => _loading = true;
  void hideLoading() => _loading = false;
  void success() => _success = true;
  void setError(String? message) => _errorMessage = message;

  void showLoadingAndResetState() {
    showLoading();
    resetState();
  }

  void resetState() {
    setError(null);
    _success = false;
  }
}
