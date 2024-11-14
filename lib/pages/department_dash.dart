import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:no_dues/Util/util.dart';
import 'package:no_dues/models/request.dart';
import 'package:no_dues/services/request_service.dart';

class DepartmentDash extends StatefulWidget {
  const DepartmentDash({super.key});

  @override
  _DepartmentDashState createState() => _DepartmentDashState();
}

class _DepartmentDashState extends State<DepartmentDash> {
  final RequestService requestService =
      RequestService(); // Initialize the service
  String userRole = "";

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  Future<void> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      setState(() {
        userRole = userDoc['role'] ?? "";
      });
    }
  }

  // Call the RequestService method to update approval status
  Future<void> handleApprovalUpdate(String requestId, String status) async {
    try {
      await requestService.updateApprovalStatus(requestId, userRole, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request updated to $status")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update approval status")),
      );
    }
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Authority dashboard"),
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
      body: StreamBuilder(
          // where is the data ? stream is representing data as snapshots -> real time documents
          stream: FirebaseFirestore.instance.collection("requests").snapshots(),
          builder: (context, snapshot) {
            //snapshot contains data in real time
            // data means collections of documents
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Please Wait")
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong. Please try again."),
              );
            }

            //length of collection is 0 i.e. no document
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No requests Found"),
              );
            }

            // List of request objects
            List<RequestModel> requests = snapshot.data!.docs
                .map((doc) => RequestModel.fromMap(
                    doc.data() as Map<String, dynamic>, doc.id))
                .toList();

            return ListView(
              children: requests
                  .map((request) => Card(
                        margin: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Name: ${request.studentName}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Branch: ${request.branch}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Generated On: ${request.submittedOn}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      handleApprovalUpdate(
                                          request.id, "Approve");
                                    },
                                    child: const Text("Approve")),
                                ElevatedButton(
                                    onPressed: () {
                                      handleApprovalUpdate(
                                          request.id, "Waiting");
                                    },
                                    child: const Text("Waiting")),
                                ElevatedButton(
                                    onPressed: () {
                                      handleApprovalUpdate(
                                          request.id, "Reject");
                                    },
                                    child: const Text("Reject"))
                              ],
                            )
                          ],
                        ),
                      ))
                  .toList(),
            );
          }),
    );
  }
}
