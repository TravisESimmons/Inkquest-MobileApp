import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized successfully!");
    runApp(const TestApp());
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
    runApp(const ErrorApp());
  }
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InkQuest Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('InkQuest Test')),
        body: const Center(
          child: Text(
            '🎉 Firebase Connected!\nInkQuest is working!',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InkQuest Error',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Error')),
        body: const Center(
          child: Text(
            '❌ Firebase initialization failed!\nCheck logs for details.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
