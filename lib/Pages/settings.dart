import 'package:flutter/material.dart';
import 'package:myapp_3/Setting%20screen/Profile%20pic/Account.dart';
import 'package:myapp_3/Setting%20screen/Profile%20pic/profile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 20,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(6),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePic(),
                      ),
                    );
                  },
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://1fid.com/wp-content/uploads/2022/06/no-profile-picture-6-1024x1024.jpg'),
                    radius: 31,
                  ),
                  title: const Text(
                    "𝙽 𝚒 𝙺 𝙺 ♡",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Hey there! I am using WhatsApp',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.qr_code,
                    ),
                    splashRadius: 20,
                  ),
                ),
                const Divider(
                  thickness: 1,
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            subtitle: const Text('Security notifiction, change number'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Account(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            subtitle: const Text('Block contacts, disppearing message'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chats'),
            subtitle: const Text('Theme, wallpapers, chat history'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Message, group & call tones'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.data_usage),
            title: const Text('Storage and Data   '),
            subtitle: const Text('Network usage, auto-download'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            subtitle: const Text('Help centre, contact us, privacy policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
