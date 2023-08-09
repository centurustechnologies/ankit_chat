import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ProfilePic extends StatefulWidget {
  final String myEmail;

  const ProfilePic({super.key, required this.myEmail});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? image;

  int current = 0;

  int index = 0;

  String originalImageName = '';

  UploadTask? uploadTask;

  Future<void> _pickImageFromCamera() async {
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // store the file
      final selectedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 75, 68),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 24,
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs
                    .where(
                      (element) =>
                          element['email'].toString().contains(widget.myEmail),
                    )
                    .length,
                itemBuilder: (context, index) {
                  final documentSnapshot = snapshot.data!.docs
                      .where(
                        (element) => element['email']
                            .toString()
                            .contains(widget.myEmail),
                      )
                      .elementAt(index);
                  return SingleChildScrollView(
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
                                    backgroundImage:
                                        NetworkImage(documentSnapshot['image']),
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
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: 200,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          title: const Text(
                                                            'Profile Photo',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          trailing: IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            splashRadius: 20,
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  height: 100,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            55,
                                                                        width:
                                                                            55,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.photo_camera,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          splashRadius:
                                                                              27,
                                                                          onPressed:
                                                                              () {
                                                                            _pickImageFromCamera();
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Text(
                                                                          'Camera',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 100,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            55,
                                                                        width:
                                                                            55,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.photo_library,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          splashRadius:
                                                                              27,
                                                                          onPressed:
                                                                              () {
                                                                            _pickImageFromGallery();
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Text(
                                                                          'Gallery',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 100,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            55,
                                                                        width:
                                                                            55,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.face,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          onPressed:
                                                                              () {},
                                                                          splashRadius:
                                                                              27,
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Text(
                                                                          'Avatar',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(Icons.person),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Name'),
                                  Container(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: documentSnapshot['name'],
                                          hintStyle:
                                              const TextStyle(fontSize: 18),
                                          suffixIcon: const Icon(Icons.edit)),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: const Text(
                                  'This name will be visible to your Contacts.'),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 72,
                              ),
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                            ListTile(
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(Icons.info_outline),
                              ),
                              title: const Text('About'),
                              subtitle: Container(
                                child: const TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          'Hey there! I am using WhatsApp',
                                      suffixIcon: Icon(Icons.edit)),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 72,
                              ),
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ListTile(
                                leading: const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Icon(Icons.call),
                                ),
                                title: const Text('Phone'),
                                subtitle: const Text('+91 82641 04734'),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          }),
    );
  }
}
