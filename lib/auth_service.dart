import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    return Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      if (email.isNotEmpty && password.isNotEmpty) {
        return 'authToken';
      } else {
        throw Exception('Error');
      }
    });
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
