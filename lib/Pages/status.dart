import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  final String myEmail;

  const Status({super.key, required this.myEmail});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs
                      .where(
                        (element) => element['email']
                            .toString()
                            .contains(widget.myEmail),
                      )
                      .length,
                  itemBuilder: (BuildContext context, index) {
                    final documentSnapshot = snapshot.data!.docs
                        .where(
                          (element) => element['email']
                              .toString()
                              .contains(widget.myEmail),
                        )
                        .elementAt(index);
                    return Column(
                      children: [
                        ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(documentSnapshot['image']),
                                radius: 31,
                              ),
                              Positioned(
                                bottom: 1,
                                right: 5,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 10, 106, 95),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                      )),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: const Text(
                            "My status",
                            strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                            'Tap to add status update',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz_outlined,
                            ),
                            splashRadius: 20,
                          ),
                        ),
                        const Divider(
                          thickness: 0.4,
                        )
                      ],
                    );
                  });
            }
            return Container();
          }),
    );
  }
}
