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
              leading: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 14, 104, 94),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.link,
                  color: Colors.white,
                  size: 30,
                ),
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
