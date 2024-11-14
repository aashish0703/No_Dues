// class Request {
//   String requestId;
//   String uid;
//   String department;
//   String status;
//   DateTime createdOn;
//   DateTime? updatedOn;

//   Request({
//     required this.requestId,
//     required this.uid,
//     required this.department,
//     this.status = 'pending',
//     required this.createdOn,
//     this.updatedOn,
//   });

//   // Convert NoDuesRequest object to Map (for Firebase)
//   Map<String, dynamic> toMap() {
//     return {
//       'requestId': requestId,
//       'uid': uid,
//       'department': department,
//       'status': status,
//       'createdOn': createdOn.toIso8601String(),
//       'updatedOn': updatedOn?.toIso8601String(),
//     };
//   }

//   // Create a NoDuesRequest object from Map
//   factory Request.fromMap(Map<String, dynamic> map) {
//     return Request(
//       requestId: map['requestId'],
//       uid: map['uid'],
//       department: map['department'],
//       status: map['status'],
//       createdOn: DateTime.parse(map['createdOn']),
//       updatedOn:
//           map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
//     );
//   }
// }

class RequestModel {
  String id; // Firestore Document ID
  String studentUid;
  String studentName;
  String branch; // Student's branch
  String submittedOn; // DateTime in String format
  Map<String, String> approvals; // Approval status from different roles
  String status; // Overall request status (Pending, Approved, Rejected)

  RequestModel({
    required this.id,
    required this.studentUid,
    required this.studentName,
    required this.branch,
    required this.submittedOn,
    required this.status,
    Map<String, String>? approvals,
  }) : approvals = approvals ??
            {
              'hod': 'Pending',
              'adviser': 'Pending',
              'fee clerk (UG)': 'Pending',
              'academic clerk (PG)': 'Pending',
              'library': 'Pending',
              'chief warden': 'Pending',
              'care taker': 'Pending',
              'mess accountant': 'Pending',
              'program coordinator (PG)': 'Pending',
              'record keeper': 'Pending',
              'supdt (A/c)': 'Pending',
              'university extension library': 'Pending'
            };

  // empty request model
  static RequestModel getEmptyRequestObject() {
    return RequestModel(
        id: '', // Empty ID for the empty object
        studentUid: "",
        studentName: "",
        branch: "",
        submittedOn: DateTime.now().toString(),
        status: "Pending");
  }

  // Convert RequestModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'studentUid': studentUid,
      'studentName': studentName,
      'branch': branch,
      'submittedOn': submittedOn,
      'approvals': approvals,
      'status': status,
    };
  }

  // Create RequestModel from Firestore Map
  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id, // Assign the document ID to the id field
      studentUid: map['studentUid'],
      studentName: map['studentName'],
      branch: map['branch'],
      submittedOn: map['submittedOn'],
      approvals: Map<String, String>.from(map['approvals']),
      status: map['status'],
    );
  }
}
