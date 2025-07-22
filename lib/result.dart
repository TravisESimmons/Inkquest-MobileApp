import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/artist.dart';
import 'home.dart';
import 'my_requests.dart';

class ResultPage extends StatelessWidget {
  final Artist artist;
  final String tattooSize;

  const ResultPage({super.key, required this.artist, required this.tattooSize});

  @override
  Widget build(BuildContext context) {
    // Calculate estimated tattoo cost based on tattoo size and artist rate
    int estimatedCost = calculateEstimatedCost();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tattoo Result'),
        backgroundColor: Colors.white,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'InkQuest',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'The Best Artist for ${artist.style} Style:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  artist.name,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Estimated Tattoo Cost:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$$estimatedCost',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your artist will be in touch shortly.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => HomePage(user: FirebaseAuth.instance.currentUser),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.list, color: Colors.white),
                      label: const Text('My Consultations'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MyRequestsPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to calculate estimated tattoo cost based on tattoo size and artist rate
  int calculateEstimatedCost() {
    int rateMultiplier = 0;
    print('tattooSize passed: $tattooSize');
    switch (tattooSize.toLowerCase()) {
      case 'small (2-3")':
        rateMultiplier = 3;
        break;
      case 'medium (5-7")':
        rateMultiplier = 7;
        break;
      case 'large (9-12")':
        rateMultiplier = 11;
        break;
      default:
        print('No match found for size');
        break;
    }
    print('Rate Multiplier: $rateMultiplier, Artist Rate: ${artist.rate}');
    return (rateMultiplier * artist.rate).round();
  }
}
