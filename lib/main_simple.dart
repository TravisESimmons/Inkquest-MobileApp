import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SimpleApp());
}

class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InkQuest Simple Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('InkQuest - Simple Test')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎉 InkQuest',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('App is working!', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text(
                'If you see this, Firebase is connected.',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
