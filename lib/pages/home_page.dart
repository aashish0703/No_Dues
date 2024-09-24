import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppBar appBar() {
    return AppBar(
      title: const Text("student dashboard"),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacement(context, '/noduesinitiated');
                    Navigator.of(context)
                        .pushReplacementNamed("/noduesinitiated");
                  },
                  child: const Text("Initiate Request")),
              const SizedBox(
                height: 10,
              ),
              const Text("Press the button to initiate No Dues request")
            ],
          ),
        ));
  }
}
