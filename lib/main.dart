import 'package:flutter/material.dart';
import 'package:future_and_streams/screens/future.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/future',
      routes: {
        '/future' : (context) => StaticFuture(),
      },
    )
  );
}
