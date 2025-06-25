import 'package:flutter/material.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

class Stows {
  final count = PlainStow('count', 0);
  // ... add more stows as needed
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ValueListenableBuilder(
            valueListenable: stows.count,
            builder: (context, value, child) {
              return Text('Count: $value');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => stows.count.value++,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
