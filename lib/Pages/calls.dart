import 'package:flutter/material.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ListTile(
              leading: const Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    backgroundImage: NetworkImage(
                      'url',
                    ),
                    radius: 28,
                  ),
                  Positioned(
                    bottom: 14,
                    right: 13,
                    child: Icon(
                      Icons.link,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              title: const Text(
                "Create call link",
                strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Share a link for your WhatsApp call',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz_outlined,
                ),
                splashRadius: 20,
              ),
            ),
          ),
          const Divider(
            thickness: 0.4,
          )
        ],
      ),
    );
  }
}
