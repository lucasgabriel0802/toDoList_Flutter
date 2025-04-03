class AuthException implements Exception {
  String message;

  AuthException({required this.message});

  @override
  String toString() {
    return message;
  }
}
