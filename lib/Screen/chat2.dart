import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userEmail, myEmail;
  const ChatScreen({
    Key? key,
    required this.userEmail,
    required this.myEmail,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String getEmailCombination() {
    List<String> emails = [widget.myEmail, widget.userEmail];
    emails.sort();
    return "${emails[0]}-${emails[1]}";
  }

  TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: width,
        backgroundColor: const Color.fromARGB(255, 8, 71, 123),
        leading: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                splashRadius: 18,
              ),
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxhtmBqlJilp6X2q2XsYxJ9DVYb_F8x17DjIOJcHtT&s'),
                radius: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rishu",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Last seen at 12:00',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // This ensures the Row takes the minimum width necessary
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam,
                  ),
                  splashRadius: 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                  ),
                  splashRadius: 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert_outlined,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.greenAccent,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('msgs')
                    .doc(getEmailCombination())
                    .collection('msg')
                    .orderBy('date_time', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        if (documentSnapshot['chatters'] ==
                            getEmailCombination()) {
                          return Wrap(
                            children: [
                              Align(
                                alignment: documentSnapshot['email'] ==
                                        widget.userEmail
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: documentSnapshot['email'] ==
                                              widget.userEmail
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 119, 214, 122),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1),
                                      ],
                                    ),
                                    child: Text(documentSnapshot['msg']),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1)
                        ]),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                              ),
                              splashRadius: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: msgController,
                                maxLines: 5,
                                minLines: 1,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type a message...."),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.attach_file),
                              splashRadius: 20,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.photo_camera,
                              ),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 8, 71, 123),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1)
                        ]),
                    child: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('msgs')
                            .doc(getEmailCombination())
                            .collection('msg')
                            .add(
                          {
                            'msg': msgController.text,
                            'email': widget.myEmail,
                            'date_time': DateTime.now().toString(),
                            'chatters': getEmailCombination(),
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      splashRadius: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        print(emoji);
      },
    );
  }
}
