import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/artist.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'my_requests.dart'; // make sure this file exists in your lib/

import 'dart:io';
import 'result.dart';

class TattooForm extends StatefulWidget {
  const TattooForm({super.key});

  @override
  _TattooFormState createState() => _TattooFormState();
}

class _TattooFormState extends State<TattooForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  int age = 0;
  String gender = '';
  String tattooDescription = '';
  String tattooSize = '';
  String tattooStyle = '';
  String tattooPlacement = '';
  List<File> _selectedImages = [];
  List<String> downloadURLs = [];

  final List<String> tattooStyles = [
    'Traditional',
    'Neo-Traditional',
    'Realism',
    'Water-Colour',
  ];

  // List of available tattoo sizes
  final List<String> tattooSizeOptions = [
    'Small (2-3")',
    'Medium (5-7")',
    'Large (9-12")',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pre-consulation Tattoo Form')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.purple],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text(
                      'InkQuest',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text('First Name', style: TextStyle(color: Colors.white)),
                TextFormField(
                  onChanged: (value) => setState(() => firstName = value),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your first name' : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                const Text('Last Name', style: TextStyle(color: Colors.white)),
                TextFormField(
                  onChanged: (value) => setState(() => lastName = value),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your last name' : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                const Text('Age', style: TextStyle(color: Colors.white)),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      setState(() => age = int.tryParse(value) ?? 0),
                  validator: (value) =>
                      value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) <= 0
                      ? 'Please enter a valid age'
                      : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                const Text('Gender', style: TextStyle(color: Colors.white)),
                TextFormField(
                  onChanged: (value) => setState(() => gender = value),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your gender' : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Describe your tattoo:                                                       (Include as much detail and as many references as possible.)',
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  onChanged: (value) =>
                      setState(() => tattooDescription = value),
                  validator: (value) => value!.isEmpty
                      ? 'Please provide a description of your tattoo'
                      : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Describe the placement or location of your tattoo:',
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  onChanged: (value) => setState(() => tattooPlacement = value),
                  validator: (value) => value!.isEmpty
                      ? 'Please specify the placement of your tattoo'
                      : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Size of your tattoo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: tattooSize.isEmpty ? null : tattooSize,
                  onChanged: (value) => setState(() => tattooSize = value!),
                  validator: (value) =>
                      value == null ? 'Please select a tattoo size' : null,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.purple,
                  items: tattooSizeOptions.map((size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(
                        size,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Select your tattoo's Style",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: tattooStyle.isEmpty ? null : tattooStyle,
                  onChanged: (value) => setState(() => tattooStyle = value!),
                  validator: (value) =>
                      value == null ? 'Please select a tattoo style' : null,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.black,
                  items: tattooStyles.map((style) {
                    return DropdownMenuItem<String>(
                      value: style,
                      child: Text(
                        style,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Selected Photo(s):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                _selectedImages.isNotEmpty
                    ? SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Image.file(
                                _selectedImages[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile>? images = await picker.pickMultiImage();
                    if (images != null && images.isNotEmpty) {
                      setState(() {
                        _selectedImages.addAll(
                          images.map((xfile) => File(xfile.path)),
                        );
                      });
                    }
                  },
                  child: const Text('Upload Reference Images'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      setState(() {
                        _selectedImages.add(File(image.path));
                      });
                    }
                  },
                  child: const Text('Take Photo'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    print('Submit button pressed');
                    if (_formKey.currentState!.validate()) {
                      print('Form validation passed');
                      final user = FirebaseAuth.instance.currentUser;
                      downloadURLs = [];
                      if (_selectedImages.isNotEmpty) {
                        for (var imageFile in _selectedImages) {
                          try {
                            print('Preparing to upload: ${imageFile.path}');
                            if (!imageFile.existsSync()) {
                              print('File does not exist: ${imageFile.path}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'File does not exist: ${imageFile.path}',
                                  ),
                                ),
                              );
                              continue;
                            }
                            int fileSize = imageFile.lengthSync();
                            print('File size: $fileSize bytes');
                            if (fileSize == 0) {
                              print('File is empty: ${imageFile.path}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'File is empty: ${imageFile.path}',
                                  ),
                                ),
                              );
                              continue;
                            }
                            String fileName =
                                '${user?.uid}_${DateTime.now().millisecondsSinceEpoch}_${_selectedImages.indexOf(imageFile)}.jpg';
                            final ref = FirebaseStorage.instance.ref().child(
                              'tattoo_images/$fileName',
                            );
                            final uploadTask = ref.putFile(imageFile);
                            final snapshot = await uploadTask;
                            final url = await snapshot.ref.getDownloadURL();
                            downloadURLs.add(url);
                          } catch (e) {
                            print('Upload failed for ${imageFile.path}: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Image upload failed: $e'),
                              ),
                            );
                            // Optionally: break or continue depending on your needs
                          }
                        }
                      }
                      Map<String, dynamic> submissionData = {
                        'userId': user != null ? user.uid : '',
                        'firstName': firstName,
                        'lastName': lastName,
                        'age': age,
                        'gender': gender,
                        'tattooDescription': tattooDescription,
                        'tattooSize': tattooSize,
                        'tattooStyle': tattooStyle,
                        'tattooPlacement': tattooPlacement,
                        'imageURL': downloadURLs,
                        'submittedAt': FieldValue.serverTimestamp(),
                        'status': 'Pending',
                      };
                      try {
                        print('Submitting data to Firestore...');
                        await FirebaseFirestore.instance
                            .collection('submissions')
                            .add(submissionData);
                        print(
                          'Submission successful! Now looking for artists...',
                        );

                        QuerySnapshot artistSnapshot = await FirebaseFirestore
                            .instance
                            .collection('artists')
                            .where('style', isEqualTo: tattooStyle)
                            .get();

                        print(
                          'Found ${artistSnapshot.docs.length} artists for style: $tattooStyle',
                        );

                        // Check if there's at least one artist found
                        if (artistSnapshot.docs.isNotEmpty) {
                          // Get the first artist found
                          Map<String, dynamic> artistData =
                              artistSnapshot.docs.first.data()
                                  as Map<String, dynamic>;
                          Artist artist = Artist.fromMap(artistData);

                          print(
                            'Navigating to ResultPage with artist: ${artist.name}',
                          );
                          // Navigate to the ResultPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                artist: artist,
                                tattooSize: tattooSize,
                              ),
                            ),
                          );
                        } else {
                          // Handle case where no artist is found for the selected style
                          print('No artists found, showing message');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No artist found for the selected style',
                              ),
                            ),
                          );
                        }
                      } catch (error) {
                        // Handle any errors that occur during submission or fetching the artist
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')),
                        );
                      }
                    } else {
                      print('Form validation failed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesome.instagram,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MyRequestsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        },
        icon: const Icon(Icons.list),
        label: const Text('My Consultations'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
