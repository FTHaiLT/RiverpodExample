import 'package:demo_riverpod/auth_provider.dart';
import 'package:demo_riverpod/home_page.dart';
import 'package:demo_riverpod/login_page.dart';
import 'package:demo_riverpod/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
      debugLogDiagnostics: false,
      refreshListenable: router,
      redirect: (context, state) {
        // return router._redirectLogic(state);
        print('redirectLogin: ${state.location}');
        final loginState = ref.read(loginViewModelProvider);
        print('redirectLogin: loginState $loginState');

        final areWeLoggingIn = state.location == '/login';

        if (loginState is LoginStateInitial) {
          return areWeLoggingIn ? null : '/login';
        }

        if (loginState is LoginStateSuccess) {
          if (areWeLoggingIn) return '/';
        }

        return null;
      },
      routes: router._routes);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      loginViewModelProvider,
      (_, __) => notifyListeners(),
    );
  }

  // String? _redirectLogic(GoRouterState state) {
  //   print('redirectLogin: ${state.location}');
  //   final loginState = _ref.read(loginViewModelProvider);
  //   print('redirectLogin: loginState $loginState');
  //
  //   final areWeLoggingIn = state.location == '/login';
  //
  //   if (loginState is LoginStateInitial) {
  //     return areWeLoggingIn ? null : '/login';
  //   }
  //
  //   if (loginState is LoginStateSuccess) {
  //     if (areWeLoggingIn) return '/';
  //   }
  //
  //   return null;
  // }

  List<GoRoute> get _routes => [
        GoRoute(
          name: 'login',
          builder: (context, state) => const LoginPage(),
          path: '/login',
        ),
        GoRoute(
          name: 'home',
          builder: (context, state) => const MyHomePage(title: 'Home Page'),
          path: '/',
        ),
      ];
}
