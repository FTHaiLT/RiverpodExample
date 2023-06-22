import 'package:demo_riverpod/home_page.dart';
import 'package:demo_riverpod/login_page.dart';
import 'package:demo_riverpod/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final router = ref.watch(routerProvider);
  //   return MaterialApp.router(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     // routeInformationParser: router.routeInformationParser,
  //     // routerDelegate: router.routerDelegate,
  //     routerConfig: router,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
