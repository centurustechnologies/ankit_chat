import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 71, 123),
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
          title: const Text("Account"),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.domain_verification),
              title: const Text('Two-step verification'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.mobile_friendly),
              title: const Text('Change number'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Request account info'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete account'),
              onTap: () {},
            ),
          ],
        ));
  }
}
