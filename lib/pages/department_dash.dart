/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:no_dues/models/request.dart';
import 'package:no_dues/services/request_service.dart';

class QuerySnapshotFake extends QuerySnapshot<Object?> {
  final List<QueryDocumentSnapshot<Object?>> _docs;

  QuerySnapshotFake(this._docs);

  @override
  List<QueryDocumentSnapshot<Object?>> get docs => _docs;

  @override
  bool get isEmpty => _docs.isEmpty;

  @override
  int get size => _docs.length;

  @override
  // Add other overridden properties or methods as needed, but the above should suffice for most use cases.
  // These methods are usually straightforward to implement or can be left as stubs if unused.
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DepartmentDash extends StatefulWidget {
  const DepartmentDash({super.key});

  @override
  _DepartmentDashState createState() => _DepartmentDashState();
}

class _DepartmentDashState extends State<DepartmentDash> {
  final RequestService requestService = RequestService();
  String userRole = "";
  String filterType = "All"; // Filter type for requests

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

  // Future<void> handleApprovalUpdate(String requestId, String status) async {
  //   String? reason;

  //   if (status == "Waiting") {
  //     reason = await showDialog<String>(
  //       context: context,
  //       builder: (context) {
  //         TextEditingController reasonController = TextEditingController();
  //         return AlertDialog(
  //           title: const Text("Provide a Reason"),
  //           content: TextField(
  //             controller: reasonController,
  //             decoration: const InputDecoration(
  //               hintText: "Enter the reason for waiting",
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, reasonController.text),
  //               child: const Text("Submit"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }

  //   if (status == "Approved" || reason != null) {
  //     try {
  //       await requestService.updateApprovalStatus(requestId, userRole, status,
  //           reason: reason);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Request updated to $status")),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Failed to update approval status")),
  //       );
  //     }
  //   }
  // }

  Future<void> handleApprovalUpdate(String requestId, String status) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the role of the logged-in user
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        String userRole = userDoc['role'] ?? "";

        // If status is "Waiting," show dialog to input the reason
        String? reason;
        if (status == "Waiting") {
          reason = await showDialog<String>(
            context: context,
            builder: (context) {
              TextEditingController reasonController = TextEditingController();
              return AlertDialog(
                title: const Text("Provide a Reason"),
                content: TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    hintText: "Enter the reason for waiting",
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, reasonController.text);
                    },
                    child: const Text("Submit"),
                  ),
                ],
              );
            },
          );
        }

        // If status is "Approved" or there's a reason for "Waiting," update Firestore
        if (status == "Approved" || reason != null) {
          DocumentReference requestRef =
              FirebaseFirestore.instance.collection("requests").doc(requestId);

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(requestRef);
            if (snapshot.exists) {
              Map<String, dynamic> requestData =
                  snapshot.data() as Map<String, dynamic>;
              Map<String, dynamic> approvals = requestData['approvals'] ?? {};

              // Update the specific role's approval
              approvals[userRole] = status;

              // If the status is "Waiting", also store the reason in the waitingReason field
              if (status == "Waiting" && reason != null) {
                Map<String, dynamic> waitingReason =
                    requestData['waitingReason'] ?? {};
                waitingReason[userRole] = reason;
                transaction.update(requestRef, {
                  'waitingReason': waitingReason,
                });
              }

              // Check if all approvals are "Approved"
              String overallStatus =
                  approvals.values.every((value) => value == "Approved")
                      ? "Approved"
                      : "Pending";

              // Update the database
              transaction.update(requestRef, {
                'approvals': approvals,
                'status': overallStatus,
              });
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request updated to $status")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update approval status")),
      );
    }
  }

  // Future<void> handleApprovalUpdate(String requestId, String status) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       // Get the role of the logged-in user
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(user.uid)
  //           .get();
  //       String userRole = userDoc['role'] ?? "";

  //       // Update the specific role's status in the approvals map
  //       DocumentReference requestRef =
  //           FirebaseFirestore.instance.collection("requests").doc(requestId);

  //       await FirebaseFirestore.instance.runTransaction((transaction) async {
  //         DocumentSnapshot snapshot = await transaction.get(requestRef);
  //         if (snapshot.exists) {
  //           Map<String, dynamic> requestData =
  //               snapshot.data() as Map<String, dynamic>;
  //           Map<String, dynamic> approvals = requestData['approvals'] ?? {};

  //           // Update the specific role's approval
  //           approvals[userRole] = status;

  //           // Check if all approvals are "Approved"
  //           String overallStatus =
  //               approvals.values.every((value) => value == "Approved")
  //                   ? "Approved"
  //                   : "Pending";

  //           // Update the database
  //           transaction.update(requestRef, {
  //             'approvals': approvals,
  //             'status': overallStatus,
  //           });
  //         }
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Request updated to $status")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to update approval status")),
  //     );
  //   }
  // }

  Stream<QuerySnapshot> getFilteredRequests() {
    CollectionReference requestsRef =
        FirebaseFirestore.instance.collection("requests");

    if (filterType == "Approved") {
      return requestsRef.where("status", isEqualTo: "Approved").snapshots();
    } else {
      return requestsRef.snapshots().asyncMap((snapshot) async {
        // Filter out documents where the logged-in authority's status is "Approved"
        List<QueryDocumentSnapshot> filteredDocs = snapshot.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Map<String, dynamic> approvals = data['approvals'] ?? {};
          return approvals[userRole] != "Approved";
        }).toList();

        // Create a new QuerySnapshot-like object
        return QuerySnapshotFake(filteredDocs);
      });
    }
  }

  // Stream<QuerySnapshot> getFilteredRequests() {
  //   CollectionReference requestsRef = FirebaseFirestore.instance.collection("requests");

  //   if (filterType == "Approved") {
  //     return requestsRef.where("status", isEqualTo: "Approved").snapshots();
  //   } else {
  //     // For "All Requests," include requests where the logged-in authority hasn't approved
  //     return requestsRef.snapshots().map((snapshot) {
  //       return snapshot.docs.where((doc) {
  //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //         Map<String, dynamic> approvals = data['approvals'] ?? {};
  //         return approvals[userRole] != "Approved"; // Only show if not approved by this role
  //       }).toList();
  //     });
  //   }
  // }

  // Stream<QuerySnapshot> getFilteredRequests() {
  //   CollectionReference requestsRef =
  //       FirebaseFirestore.instance.collection("requests");
  //   if (filterType == "Approved") {
  //     return requestsRef
  //         .where("status", isEqualTo: "Approved")
  //         .snapshots(); // for approved requests
  //   }
  //   // } else if (filterType == "Rejected") {
  //   //   return requestsRef.where("status", isEqualTo: "Rejected").snapshots();
  //   // }
  //   else {
  //     return requestsRef
  //         .where("status", isNotEqualTo: "Approved")
  //         .snapshots(); // for all requests except approved
  //   }
  // }

  AppBar appBar() {
    return AppBar(
      title: const Text("Authority Dashboard"),
      actions: [
        IconButton(
          onPressed: () {
            logout(context);
          },
          icon: const Icon(Icons.logout),
        ),
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filterType = "All";
                  });
                },
                child: const Text("All Requests"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filterType = "Approved";
                  });
                },
                child: const Text("Approved Requests"),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       filterType = "Rejected";
              //     });
              //   },
              //   child: const Text("Rejected Requests"),
              // ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: getFilteredRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Please Wait"),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong. Please try again."),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No requests Found"),
                  );
                }

                List<RequestModel> requests = snapshot.data!.docs
                    .map((doc) => RequestModel.fromMap(
                        doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                return ListView(
                  children: requests
                      .map(
                        (request) => Card(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: request.status == "Approved"
                                        ? null
                                        : () {
                                            handleApprovalUpdate(
                                                request.id, "Approved");
                                          },
                                    child: const Text("Approve"),
                                  ),
                                  ElevatedButton(
                                    onPressed: request.status == "Approved"
                                        ? null
                                        : () {
                                            handleApprovalUpdate(
                                                request.id, "Waiting");
                                          },
                                    child: const Text("Waiting"),
                                  ),
                                  ElevatedButton(
                                    onPressed: request.status == "Approved"
                                        ? null
                                        : () {
                                            handleApprovalUpdate(
                                                request.id, "Reject");
                                          },
                                    child: const Text("Reject"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
