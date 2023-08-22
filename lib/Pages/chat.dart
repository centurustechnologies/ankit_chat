import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp_3/Screen/chat2.dart';

class Chatpagein extends StatefulWidget {
  final String myEmail;
  const Chatpagein({
    super.key,
    required this.myEmail,
  });

  @override
  State<Chatpagein> createState() => _ChatpageinState();
}

class _ChatpageinState extends State<Chatpagein> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              if (documentSnapshot.id != widget.myEmail) {
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        myEmail: widget.myEmail,
                        userEmail: documentSnapshot['email'],
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(documentSnapshot['image']),
                          radius: 30,
                        ),
                        title: Text(
                          documentSnapshot["name"],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(
                              Icons.done_all,
                              size: 16,
                            ),
                            Text(
                              documentSnapshot['subtitle'],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Text(
                          documentSnapshot['time'],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20, left: 80),
                        child: Divider(
                          height: 0,
                          thickness: 0.4,
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        }

        return Container();
      },
    );
  }
}
