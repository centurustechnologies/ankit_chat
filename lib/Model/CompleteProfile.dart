import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp_3/main.dart';
import 'package:path/path.dart' as path;

class CompleteProfile extends StatefulWidget {
  final String myEmail;
  const CompleteProfile({super.key, required this.myEmail});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.camera);
                  },
                  leading: IconButton(
                    icon: const Icon(
                      Icons.photo_camera,
                      size: 20,
                      color: Colors.green,
                    ),
                    splashRadius: 1,
                    onPressed: () {},
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.gallery);
                  },
                  leading: IconButton(
                    icon: const Icon(
                      Icons.photo_library,
                      size: 20,
                      color: Colors.green,
                    ),
                    splashRadius: 1,
                    onPressed: () {},
                  ),
                  title: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  TextEditingController _nameTextController = TextEditingController();
  var storage = const FlutterSecureStorage();
  File? image;

  int current = 0;

  int index = 0;

  String originalImageName = '';

  UploadTask? uploadTask;

  Future<void> selectImage(source) async {
    try {
      // store the file
      final selectedImage = await ImagePicker().pickImage(source: source);
      if (selectedImage == null) return;
      final tempimage = File(selectedImage.path);
      final imageName = path.basenameWithoutExtension(tempimage.path);
      final newFileName =
          await tempimage.rename('${tempimage.parent.path}/$imageName.png');
      log('new image is $newFileName ${tempimage.parent.path}');

      setState(() {
        image = newFileName;
        originalImageName = "$imageName.png";
        uploadFile();
      });
    } on Exception catch (e) {
      log('new image exception is $e');
    }
  }

  Future uploadFile() async {
    try {
      final path = "users/$originalImageName";
      final file = File(image!.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

      final url = await snapshot.ref.getDownloadURL();

      log('url $url');

      setState(() {
        uploadTask = null;
      });
      updateImageAndDocument(url);
    } on Exception catch (e) {
      log('error upload $e');
    }
  }

  Future updateImageAndDocument(String newImageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.myEmail)
          .update({
        'image': newImageUrl,
        // other fields you want to update
      });
      log('image update with new url');
    } catch (e) {
      log('error in update image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        title: Text("Complete Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: SizedBox(
                  height: 140,
                  width: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(""),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () {
                              showPhotoOption();
                            },
                            child: const Icon(Icons.photo_camera,
                                color: Colors.white, size: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(labelText: "Full Name"),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              width: 400,
              height: 60,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text('Save'),
                  onPressed: () {
                    if (_nameTextController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Please fill the details.",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text(
                            "Congrulation, your Profile has been successfully created.",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            myEmail: '',
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void storeLoginData(email) async {
    await storage.write(key: 'email', value: email);
  }
}
