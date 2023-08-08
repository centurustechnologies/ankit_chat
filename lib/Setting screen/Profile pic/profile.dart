import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? image;

  int current = 0;

  int index = 0;

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
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
      });
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
                      image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(image!),
                            )
                          : const CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  "https://1fid.com/wp-content/uploads/2022/06/no-profile-picture-6-1024x1024.jpg"),
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
                              showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: const Text(
                                                'Profile Photo',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.black,
                                                ),
                                                splashRadius: 20,
                                                onPressed: () {},
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                            height: 55,
                                                            width: 55,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .photo_camera,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              splashRadius: 27,
                                                              onPressed: () {
                                                                _pickImageFromCamera();
                                                              },
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            child: Text(
                                                              'Camera',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
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
                                                            height: 55,
                                                            width: 55,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .photo_library,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              splashRadius: 27,
                                                              onPressed: () {
                                                                _pickImageFromGallery();
                                                              },
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            child: Text(
                                                              'Gallery',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
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
                                                            height: 55,
                                                            width: 55,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.face,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              onPressed: () {},
                                                              splashRadius: 27,
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            child: Text(
                                                              'Avatar',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
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
                        child: const TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '𝙽 𝚒 𝙺 𝙺 ♡',
                              hintStyle: TextStyle(fontSize: 18),
                              suffixIcon: Icon(Icons.edit)),
                        ),
                      ),
                    ],
                  ),
                  subtitle:
                      const Text('This name will be visible to your Contacts.'),
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
                          hintText: 'Hey there! I am using WhatsApp',
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
                  padding: const EdgeInsets.only(left: 8, right: 8),
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
      ),
    );
  }
}
