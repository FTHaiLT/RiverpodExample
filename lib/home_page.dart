import 'package:demo_riverpod/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final testProvider =
Provider((ref) => 'You have pushed the button this many times:');
final testStateProvider = StateProvider((ref) => 0);
final testFutureProvider = FutureProvider<String>((ref) async {
  DateTime current = DateTime.now();
  return DateFormat.Hms().format(current);
});

final testStreamProvider = StreamProvider((ref) =>
    Stream<int>.periodic(const Duration(seconds: 1), (count) => count)
        .take(10));

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
            Consumer(
              builder: (context, ref, child) {
                return Text(ref.watch(testProvider));
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return ConsumerText(
                    data:
                    'StateNotifierProvider: ${ref.watch(counterProvider)}');
              },
              // child: Text(
              //   '${ref.watch(counterProvider)}',
              //   style: Theme.of(context).textTheme.headlineMedium,
              // ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return Text('StateProvider: ${ref.watch(testStateProvider)}');
              },
            ),
            Consumer(builder: (context, ref, child) {
              var asyncDateString = ref.watch(testFutureProvider);
              return asyncDateString.when<Widget>(
                  data: (dateString) => Text('Future Provider: $dateString'),
                  error: (e, s) => Text(e.toString()),
                  loading: () => const CircularProgressIndicator());
            }),
            Consumer(builder: (context, ref, child) {
              var stream = ref.watch(testStreamProvider);
              return stream.when(data: (value) => Text(value.toString()),
                  error: (e, s) => Text(e.toString()),
                  loading: () => const CircularProgressIndicator());
            })
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 1,
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
                heroTag: 2,
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
      style: Theme
          .of(context)
          .textTheme
          .headlineSmall,
    );
  }
}
