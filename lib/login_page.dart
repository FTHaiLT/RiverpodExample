import 'package:demo_riverpod/auth_provider.dart';
import 'package:demo_riverpod/home_page.dart';
import 'package:demo_riverpod/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(loginViewModelProvider, (previous, next) {
      print('object $next');
      if (next is LoginStateLoading) {
        // show loading
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Loading...'),
            );
          },
        );
      } else {
        Navigator.of(context).pop();
      }

      if (next is LoginStateSuccess) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Home page'),
          ),
          (route) => false,
        );
      }
      // else if (next is LoginStateError) {
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       content: Text(next.error),
        //     );
        //   },
        // );
      // }
    });

    final state = ref.watch(loginViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                child: Visibility(
                  visible: state is LoginStateError,
                  child: Text(
                    state is LoginStateError ? state.error : "",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      ref
                          .read(loginViewModelProvider.notifier)
                          .login(emailController.text, passwordController.text);
                    },
                  )),
            ],
          )),
    );
  }
}
