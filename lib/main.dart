import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
      title: 'Weather App',

      home:  Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(

          title: const Text('Weather App'),

        ),
        body: Center(

          child: Text(
            "This is my First App",
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade800),
          ),
        ),

      ),
    );
  }
}
