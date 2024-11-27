// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class NoDuesInitiated extends StatefulWidget {
//   const NoDuesInitiated({super.key});

//   @override
//   _NoDuesInitiatedState createState() => _NoDuesInitiatedState();
// }

// class _NoDuesInitiatedState extends State<NoDuesInitiated> {
//   AppBar appBar() {
//     return AppBar(
//       title: const Text("Student dashboard"),
//       actions: [
//         IconButton(
//             onPressed: () {
//               logout(context);
//             },
//             icon: const Icon(Icons.logout))
//       ],
//     );
//   }

//   logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacementNamed(context, "/login-student");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           children: [
//             Container(
//               child: Row(
//                 children: [
//                   const Text("Department Name"),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   const Text("Status")
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
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

  Future<QuerySnapshot> fetchStudentRequests(String studentUid) async {
    return await FirebaseFirestore.instance
        .collection('requests')
        .where('studentUid', isEqualTo: studentUid)
        .get();
  }

  Future<void> generateAndSavePdf(BuildContext context, String studentName,
      String branch, Map<String, dynamic> approvals) async {
    final pdf = pw.Document();

    // Load the font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("No Dues Clearance Certificate",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.SizedBox(height: 20),
              pw.Text("Student Name: $studentName",
                  style: pw.TextStyle(font: ttf)),
              pw.Text("Branch: $branch", style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 20),
              pw.Text("Approval Status:",
                  style:
                      pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
              ...approvals.entries.map((entry) {
                return pw.Text("${entry.key}: ${entry.value}",
                    style: pw.TextStyle(font: ttf));
              }),
            ],
          );
        },
      ),
    );

    try {
      // Let the user pick a location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        // Define the file path
        final filePath = "$selectedDirectory/no_dues_certificate.pdf";

        // Save the PDF
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF saved successfully at $filePath")),
        );
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Save operation canceled.")),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
    }
  }

  bool allApproved(Map<String, dynamic> approvals) {
    // if (approvals.isEmpty) return false;
    return approvals.values.every((status) => status == "Approved");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: FutureBuilder<QuerySnapshot>(
        future: fetchStudentRequests(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No requests found."));
          }

          // Fetch the first document (assuming one request per student)
          var requestData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          Map<String, dynamic> approvals =
              requestData['approvals'] as Map<String, dynamic>;
          Map<String, dynamic> waitingReasons =
              requestData['waitingReason'] as Map<String, dynamic>? ?? {};

          String studentName = requestData['studentName'] ?? "Unknown Student";
          String branch = requestData['branch'] ?? "Unknown Branch";

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: approvals.keys.length,
                  itemBuilder: (context, index) {
                    String authority = approvals.keys.elementAt(index);
                    String status = approvals[authority];

                    return ListTile(
                      leading: Icon(
                        status == "Approved"
                            ? Icons.check_circle
                            : status == "Rejected"
                                ? Icons.cancel
                                : Icons.hourglass_empty,
                        color: status == "Approved"
                            ? Colors.green
                            : status == "Rejected"
                                ? Colors.red
                                : Colors.orange,
                      ),
                      title: Text(authority),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: $status"),
                          if (status == "Waiting" &&
                              waitingReasons.containsKey(authority))
                            Text("Reason: ${waitingReasons[authority]}",
                                style: const TextStyle(color: Colors.orange)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (allApproved(approvals)) {
                    // await generateAndSavePdf(
                    //     context, studentName, branch, approvals);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //       content: Text("PDF downloaded successfully!")),
                    // );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Information'),
                          content: const Text('Contact department clerk'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the dialog when button is pressed
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Request not fully approved yet.")),
                    );
                  }
                },
                child: const Text("Download PDF"),
              )
            ],
          );
        },
      ),
    );
  }
}



// Future<void> generatePdf(
  //     String studentName, String branch, Map<String, dynamic> approvals) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text("No Dues Clearance Certificate",
  //                 style: pw.TextStyle(
  //                     fontSize: 20, fontWeight: pw.FontWeight.bold)),
  //             pw.SizedBox(height: 20),
  //             pw.Text("Student Name: $studentName"),
  //             pw.Text("Branch: $branch"),
  //             pw.SizedBox(height: 20),
  //             pw.Text("Approval Status:",
  //                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             pw.ListView.builder(
  //               itemCount: approvals.keys.length,
  //               itemBuilder: (context, index) {
  //                 String authority = approvals.keys.elementAt(index);
  //                 String status = approvals[authority];
  //                 return pw.Text("$authority: $status");
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   // Save the PDF file to the device
  //   final output = await getApplicationDocumentsDirectory();
  //   final file = File("${output.path}/no_dues_certificate.pdf");
  //   await file.writeAsBytes(await pdf.save());
  // }

  // Future<void> generatePdf(
  //     String studentName, String branch, Map<String, dynamic> approvals) async {
  //   final pdf = pw.Document();

  //   // Load the font
  //   final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  //   final ttf = pw.Font.ttf(fontData);

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text("No Dues Clearance Certificate",
  //                 style: pw.TextStyle(
  //                     fontSize: 20, fontWeight: pw.FontWeight.bold, font: ttf)),
  //             pw.SizedBox(height: 20),
  //             pw.Text("Student Name: $studentName",
  //                 style: pw.TextStyle(font: ttf)),
  //             pw.Text("Branch: $branch", style: pw.TextStyle(font: ttf)),
  //             pw.SizedBox(height: 20),
  //             pw.Text("Approval Status:",
  //                 style:
  //                     pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
  //             ...approvals.entries.map((entry) {
  //               return pw.Text("${entry.key}: ${entry.value}",
  //                   style: pw.TextStyle(font: ttf));
  //             }),
  //           ],
  //         );
  //       },
  //     ),
  //   );

  //   // Save the PDF file
  //   final output = await getApplicationDocumentsDirectory();
  //   final file = File("${output.path}/no_dues_certificate.pdf");
  //   await file.writeAsBytes(await pdf.save());
  //   print("PDF saved to: ${file.path}");
  // }