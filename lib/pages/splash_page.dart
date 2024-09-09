import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF8ACDD7),
        body: Center(
          child: Text('SnoutSaver'),
        ),
      ),
    );
  }
}