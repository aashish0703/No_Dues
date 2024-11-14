import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoDuesInitiated extends StatefulWidget {
  const NoDuesInitiated({super.key});

  @override
  _NoDuesInitiatedState createState() => _NoDuesInitiatedState();
}

class _NoDuesInitiatedState extends State<NoDuesInitiated> {
  AppBar appBar() {
    return AppBar(
      title: const Text("Student dashboard"),
      actions: [
        IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout))
      ],
    );
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/login-student");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  const Text("Department Name"),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("Status")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
