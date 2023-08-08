import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://1fid.com/wp-content/uploads/2022/06/no-profile-picture-6-1024x1024.jpg'),
                  radius: 31,
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 25,
                  ),
                ),
              ],
            ),
            title: const Text(
              "My status",
              strutStyle: StrutStyle(fontWeight: FontWeight.bold),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
