import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tattoo_form.dart';
import 'my_requests.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to InkQuest'),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.purple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/inkquest_logo.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Icon(Icons.brush, size: 120, color: Colors.white);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to InkQuest!',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                user != null
                    ? 'Hello, ${user!.displayName ?? user!.email ?? 'User'}'
                    : '',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Book a Consultation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TattooForm()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.list, color: Colors.white),
                label: const Text('My Consultations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyRequestsPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text('Setup Artists (One-time)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  await _populateArtists(context);
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _populateArtists(BuildContext context) async {
    try {
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

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Adding artists to database..."),
              ],
            ),
          );
        },
      );

      // Add each artist to the 'artists' collection
      for (int i = 0; i < artists.length; i++) {
        await firestore.collection('artists').add(artists[i]);
      }

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Successfully added ${artists.length} artists to database!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog if it's open
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error adding artists: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
