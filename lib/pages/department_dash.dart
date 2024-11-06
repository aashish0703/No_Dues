import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:no_dues/models/request.dart';

class DepartmentDash extends StatefulWidget {
  const DepartmentDash({super.key});

  @override
  _DepartmentDashState createState() => _DepartmentDashState();
}

class _DepartmentDashState extends State<DepartmentDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text("No Turf Found"),
              );
            }

            // List of request objects
            List<RequestModel> requests = snapshot.data!.docs
                .map((doc) =>
                    RequestModel.fromMap(doc.data() as Map<String, dynamic>))
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
                                    onPressed: () {},
                                    child: const Text("Approve")),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Waiting")),
                                ElevatedButton(
                                    onPressed: () {},
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
