import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class ConsultationDetailPage extends StatelessWidget {
  final Map<String, dynamic> request;
  const ConsultationDetailPage({Key? key, required this.request})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = request['imageURL'] is List
        ? List<String>.from(request['imageURL'])
        : (request['imageURL'] != null && request['imageURL'] != '')
        ? [request['imageURL'] as String]
        : <String>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultation Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF533483),
              Color(0xFF8E4EC6),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              request['tattooDescription'] ?? 'Tattoo Request',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 16),
            if (images.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: images.length,
                itemBuilder: (context, idx) {
                  final url = images[idx];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: InteractiveViewer(
                            child: Image.network(url, fit: BoxFit.contain),
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: url,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white38,
                                  size: 48,
                                ),
                              ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black26,
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white38,
                    size: 48,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Placement: ${request['tattooPlacement'] ?? 'N/A'}\n',
                  ),
                  TextSpan(text: 'Size: ${request['tattooSize'] ?? 'N/A'}\n'),
                  TextSpan(text: 'Style: ${request['tattooStyle'] ?? 'N/A'}\n'),
                  TextSpan(text: 'Status: ${request['status'] ?? 'Pending'}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyRequestsPage extends StatefulWidget {
  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  Widget _buildImageSection(dynamic imageField) {
    // Support both single image URL (String) and list of URLs (List<String>)
    if (imageField is String) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black26,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageField,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, color: Colors.white38, size: 48),
            ),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.purple),
              );
            },
          ),
        ),
      );
    } else if (imageField is List && imageField.isNotEmpty) {
      return SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageField.length,
          separatorBuilder: (context, idx) => const SizedBox(width: 8),
          itemBuilder: (context, idx) {
            final url = imageField[idx];
            return Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black26,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white38,
                      size: 48,
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _fetchUserRequests() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('DEBUG: No user logged in');
      return [];
    }

    print('DEBUG: Current user ID: ${user.uid}');

    try {
      // Temporary fix: Remove orderBy to avoid index requirement
      final snapshot = await FirebaseFirestore.instance
          .collection('submissions')
          .where('userId', isEqualTo: user.uid)
          .get();

      print('DEBUG: Found ${snapshot.docs.length} submissions');

      // Let's also check ALL submissions to see if there are any
      final allSnapshot = await FirebaseFirestore.instance
          .collection('submissions')
          .get();

      print('DEBUG: Total submissions in database: ${allSnapshot.docs.length}');

      if (allSnapshot.docs.isNotEmpty) {
        for (var doc in allSnapshot.docs) {
          print(
            'DEBUG: Submission userId: ${doc.data()['userId']}, current user: ${user.uid}',
          );
        }
      }

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('DEBUG: Error fetching requests: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Consultations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      HomePage(user: FirebaseAuth.instance.currentUser),
                ),
                (route) => false,
              );
            },
            tooltip: 'Home',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF533483),
              Color(0xFF8E4EC6),
            ],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchUserRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.purple),
                    const SizedBox(height: 16),
                    const Text(
                      'Loading your consultations...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No consultations found.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ConsultationDetailPage(request: req),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.black54,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req['tattooDescription'] ?? 'Tattoo Request',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (req['imageURL'] != null && req['imageURL'] != '')
                            _buildImageSection(req['imageURL'])
                          else
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black26,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white38,
                                  size: 48,
                                ),
                              ),
                            ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'Placement: ${req['tattooPlacement'] ?? 'N/A'}\n',
                                ),
                                TextSpan(
                                  text: 'Size: ${req['tattooSize'] ?? 'N/A'}\n',
                                ),
                                TextSpan(
                                  text:
                                      'Style: ${req['tattooStyle'] ?? 'N/A'}\n',
                                ),
                                TextSpan(
                                  text: 'Status: ${req['status'] ?? 'Pending'}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
