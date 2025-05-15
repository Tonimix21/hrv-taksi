
import 'package:flutter/material.dart';

void main() => runApp(HrvTaksiApp());

class HrvTaksiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HrvTaksi',
      home: Scaffold(
        appBar: AppBar(title: Text('HrvTaksi')),
        body: Center(child: Text('Dobrodošli u HrvTaksi aplikaciju!')),
      ),
    );
  }
}
