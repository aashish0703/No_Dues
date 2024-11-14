/*
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:no_dues/Util/util.dart";
import "package:no_dues/models/request.dart";
import "package:no_dues/services/request_service.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RequestService service = RequestService();
  RequestModel request = RequestModel.getEmptyRequestObject();
  bool showProgress = false;

  // addRequestToDb() async {
  //   String result = await service.addRequest(request);
  //   const message = SnackBar(content: Text("REQUEST INITIATED"));
  //   ScaffoldMessenger.of(context).showSnackBar(message);
  //   if (result.contains("successfully")) {
  //     setState(() {
  //       showProgress = false;
  //     });
  //   }
  // }

  // final User? user = FirebaseAuth.instance.currentUser;

  Future<void> initiateRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(Util.UID)
          .get();

      if (userDoc.exists) {
        final name = userDoc.get("name") ?? "No name";
        final branch = userDoc.get("branch") ?? "No branch";

        // RequestModel request = RequestModel.getEmptyRequestObject();

        // Fill in the necessary user details
        request.studentUid = user.uid;
        request.studentName = name;
        request.branch = branch; // Set the branch from Firestore
        request.submittedOn = DateTime.now().toString();
        request.status = "Pending"; // Default status
      }
      try {
        // // Save the request to Firestore
        // await FirebaseFirestore.instance
        //     .collection('requests')
        //     .doc(Util.requestId)
        //     .set(request.toMap())
        //     .then((value) {
        //   print("User data ${request.toMap().toString()} Saved in Firestore");
        // });

        String? result = await service.addRequest(request);
        if (result != null) {
          // Request added successfully
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Request initiated successfully. ID: $result")),
            );
          }
        } else {
          // Failed to add request
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to initiate request.")),
          );
        }
        Navigator.pushReplacementNamed(context, "/noduesinitiated");
      } catch (e) {
        print("Error adding request to database : $e");
      }
    } else {
      // User document does not exist
      print("user data not exist");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not found.")),
      );
    }
  }

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
                    initiateRequest();
                    // Navigator.pushReplacement(context, '/noduesinitiated');
                    // Navigator.of(context)
                    //     .pushReplacementNamed("/noduesinitiated");
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
*/

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:no_dues/Util/util.dart";
import "package:no_dues/models/request.dart";
import "package:no_dues/services/request_service.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RequestService service = RequestService();
  RequestModel request = RequestModel.getEmptyRequestObject();
  bool showProgress = false;

  // addRequestToDb() async {
  //   String result = await service.addRequest(request);
  //   const message = SnackBar(content: Text("REQUEST INITIATED"));
  //   ScaffoldMessenger.of(context).showSnackBar(message);
  //   if (result.contains("successfully")) {
  //     setState(() {
  //       showProgress = false;
  //     });
  //   }
  // }

  // final User? user = FirebaseAuth.instance.currentUser;

  Future<void> initiateRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId == null) return; // Check for authenticated user

    // Step 1: Check if a request already exists
    final querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('studentUid', isEqualTo: userId)
        .get();

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(Util.UID)
          .get();

      if (userDoc.exists) {
        final name = userDoc.get("name") ?? "No name";
        final branch = userDoc.get("branch") ?? "No branch";

        // Fill in the necessary user details
        request.studentUid = user.uid;
        request.studentName = name;
        request.branch = branch; // Set the branch from Firestore
        request.submittedOn = DateTime.now().toString();
        request.status = "Pending"; // Default status
      }

      if (querySnapshot.docs.isNotEmpty) {
        // If a request exists, show a message or prevent further action
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("You have already submitted a request")),
          );
        }
        Navigator.of(context).pushReplacementNamed("/noduesinitiated");
      } else {
        // Step 2: If no request found, create a new one
        try {
          // // Save the request to Firestore
          // await FirebaseFirestore.instance
          //     .collection('requests')
          //     .doc(Util.requestId)
          //     .set(request.toMap())
          //     .then((value) {
          //   print("User data ${request.toMap().toString()} Saved in Firestore");
          // });

          String? result = await service.addRequest(request);
          if (result != null) {
            // Request added successfully
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text("Request initiated successfully. ID: $result")),
              );
            }
          } else {
            // Failed to add request
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to initiate request.")),
            );
          }
          Navigator.pushReplacementNamed(context, "/noduesinitiated");
        } catch (e) {
          print("Error adding request to database : $e");
        }
      }
    } else {
      // User document does not exist
      print("user data not exist");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not found.")),
      );
    }
  }

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
                    initiateRequest();
                    // Navigator.pushReplacement(context, '/noduesinitiated');
                    // Navigator.of(context)
                    //     .pushReplacementNamed("/noduesinitiated");
                  },
                  child: const Text("Initiate Request")),
              const SizedBox(
                height: 10,
              ),
              const Text("Press the button to initiate No Dues request"),
            ],
          ),
        ));
  }
}
