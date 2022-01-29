import 'package:flutter/material.dart';

import 'application/pages/main.dart';

void main() {
  runApp(const IntercomApp());
}

class IntercomApp extends StatelessWidget {
  const IntercomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Intercom';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
