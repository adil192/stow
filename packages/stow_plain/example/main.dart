import 'package:flutter/material.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

class Stows {
  final count = PlainStow.simple('count', 0);
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
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: stows.count,
                builder: (context, value, child) {
                  return Text('Count: $value');
                },
              ),
              ElevatedButton(
                onPressed: () => stows.count.value++,
                child: Text('Increment Count'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
