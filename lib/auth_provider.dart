import 'package:demo_riverpod/auth_viewmodel.dart';
import 'package:demo_riverpod/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref);
});
