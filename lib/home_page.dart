import 'package:demo_riverpod/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('MyHomePage build');

    ref.listen(counterProvider, (previous, next) {
      print('previous $previous next $next');
      int value = next as int;
      if (value > 0 && value % 10 == 0) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Checkpoint: $next'),
            );
          },
        );
      }
    });

    final counter = ref.watch(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer(
              builder: (context, ref, child) {
                return ConsumerText(data: '${ref.watch(counterProvider)}');
              },
              // child: Text(
              //   '${ref.watch(counterProvider)}',
              //   style: Theme.of(context).textTheme.headlineMedium,
              // ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () => counter.increment(),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 32),
              child: FloatingActionButton(
                onPressed: () => _resetCounter(ref),
                tooltip: 'Reset',
                child: const Icon(Icons.autorenew_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _incrementCounter(WidgetRef ref) {
    ref.read(counterProvider.notifier).increment();
  }

  void _resetCounter(WidgetRef ref) {
    ref.invalidate(counterProvider);
  }
}

class ConsumerText extends StatelessWidget {
  final String data;

  const ConsumerText({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ConsumerText build');
    return Text(
      data,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
