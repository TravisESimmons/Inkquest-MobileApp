import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';

// Sample data to populate Firestore with artists
void main() async {
  // Initialize Flutter binding first
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  // Sample artists with different styles and rates
  final artists = [
    // Traditional style artists
    {
      'name': 'Jake Morrison',
      'style': 'Traditional',
      'rate': 150, // per hour
    },
    {'name': 'Sarah Chen', 'style': 'Traditional', 'rate': 180},

    // Realism style artists
    {'name': 'Marcus Rodriguez', 'style': 'Realism', 'rate': 200},
    {'name': 'Emma Thompson', 'style': 'Realism', 'rate': 220},

    // Watercolor style artists
    {'name': 'Alex Kim', 'style': 'Watercolor', 'rate': 170},
    {'name': 'Luna Martinez', 'style': 'Watercolor', 'rate': 190},

    // Geometric style artists
    {'name': 'David Park', 'style': 'Geometric', 'rate': 160},
    {'name': 'Rachel Green', 'style': 'Geometric', 'rate': 175},

    // Minimalist style artists
    {'name': 'Tyler Johnson', 'style': 'Minimalist', 'rate': 140},
    {'name': 'Zoe Wilson', 'style': 'Minimalist', 'rate': 155},

    // Japanese style artists
    {'name': 'Hiroshi Tanaka', 'style': 'Japanese', 'rate': 210},
    {'name': 'Akira Suzuki', 'style': 'Japanese', 'rate': 195},
  ];

  print('Adding ${artists.length} artists to Firestore...');

  try {
    // Add each artist to the 'artists' collection
    for (int i = 0; i < artists.length; i++) {
      await firestore.collection('artists').add(artists[i]);
      print('Added artist ${i + 1}/${artists.length}: ${artists[i]['name']}');
    }

    print('✅ Successfully added all artists to Firestore!');
    print('You can now test the tattoo form submission.');
  } catch (e) {
    print('❌ Error adding artists: $e');
  }
}
