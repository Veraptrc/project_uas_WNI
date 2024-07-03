import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas_wni/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _description = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  GlobalKey<FormState> key = GlobalKey();
  XFile? _image;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.cancel))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _image = pickedFile;
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/images/camera.png',
                    height: 50,
                    width: 50,

                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 376,
                  height: 300,
                  child: TextField(
                    controller: _description,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Masukkan Deskripsi Posting"),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: FloatingActionButton(
              onPressed: () async {
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please upload an image'),
                  ));
                  return;
                }
                String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');
                Reference referenceImageToUpload =
                referenceDirImages.child(uniqueFileName);
                try {
                  await referenceImageToUpload.putFile(File(_image!.path));
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                  final CollectionReference reference =
                  FirebaseFirestore.instance.collection('posts');
                  await reference.add({
                    'description' : _description.text,
                    'image': imageUrl,
                    'timestamp' : Timestamp.now(),
                    'email' : _user?.email,
                  });
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error uploading image: $error')),
                  );
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text("Post"),
            ),
          )
        ],
      ),
    );
  }
}