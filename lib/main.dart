import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp_3/Model/CompleteProfile.dart';
import 'package:myapp_3/Model/Login.dart';
import 'package:myapp_3/Pages/calls.dart';
import 'package:myapp_3/Pages/chat.dart';
import 'package:myapp_3/Pages/status.dart';
import 'package:myapp_3/Setting%20screen/SettingsScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  !kIsWeb
      ? await Firebase.initializeApp()
      : await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBinWt11DKBgmpoPqKkLImfBk2O7N_uG5k",
              appId: "1:230897717719:web:a209686dd4623b311afb92",
              messagingSenderId: "230897717719",
              projectId: "my-app3-88105"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var storage = const FlutterSecureStorage();
  var alreadyLogin = '';

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CompleteProfile(
        myEmail: '',
      ),

      //  alreadyLogin.toString().isEmpty
      //     ? const LoginPage()
      //     : Home(
      //         myEmail: alreadyLogin.toString(),
      //       ),
      // home: Home(myEmail: 'myEmail'),
    );
  }

  Future<String?> getEmail() async {
    return await storage.read(key: 'email');
  }

  checkLogin() async {
    String? emailToken = await getEmail();
    if (emailToken != null) {
      setState(() {
        alreadyLogin = emailToken.toString();
      });
    }
  }
}

class Home extends StatefulWidget {
  final String myEmail;
  const Home({Key? key, required this.myEmail}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Update this with the number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 8, 71, 123),
          title: const Text(
            "Chat App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
              splashRadius: 20,
            ),
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'Settings':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingScreen(myEmail: widget.myEmail),
                      ),
                    );

                  case 'Log Out':
                    log("message");
                    setState(() {
                      storage.delete(key: 'email');
                    });
                    Navigator.pop(context);
                }
              },
              splashRadius: 20,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: "New group",
                    child: Text("New group"),
                  ),
                  const PopupMenuItem(
                    value: "New broadcast",
                    child: Text("New broadcast"),
                  ),
                  const PopupMenuItem(
                    value: "WhatsApp Web",
                    child: Text("WhatsApp Web"),
                  ),
                  const PopupMenuItem(
                    value: "Starred Message",
                    child: Text("Starred Message"),
                  ),
                  const PopupMenuItem(
                    value: "Settings",
                    child: Text("Settings"),
                  ),
                  PopupMenuItem(
                    value: "Log Out",
                    child: const Text("Log Out"),
                    onTap: () {},
                  ),
                ];
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            isScrollable: false,
            tabs: [
              Tab(
                child: Text(
                  'Chats',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Status',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Calls',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chatpagein(
              myEmail: widget.myEmail,
            ),

            // for Status
            Status(
              myEmail: widget.myEmail,
            ),

            // for Calls
            const Call(),
          ],
        ),
      ),
    );
  }
}
