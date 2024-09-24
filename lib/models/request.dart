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
  String studentUid;
  String studentName;
  String branch; // Student's branch
  String submittedOn; // DateTime in String format
  Map<String, String> approvals; // Approval status from different roles
  String status; // Overall request status (Pending, Approved, Rejected)

  RequestModel({
    required this.studentUid,
    required this.studentName,
    required this.branch,
    required this.submittedOn,
    required this.status,
    Map<String, String>? approvals,
  }) : approvals = approvals ??
            {
              'HOD': 'Pending',
              'adviser': 'Pending',
              'Fee Clerk (UG)': 'Pending',
              'Academic Clerk (PG)': 'Pending',
              'Library': 'Pending',
              'Chief Warden': 'Pending',
              'Care Taker': 'Pending',
              'Mess Accountant': 'Pending',
              'Program Coordinator (PG)': 'Pending',
              'Record Keeper': 'Pending',
              'Supdt (A/c)': 'Pending',
              'University Extension Library': 'Pending'
            };

  // empty request

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
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      studentUid: map['studentUid'],
      studentName: map['studentName'],
      branch: map['branch'],
      submittedOn: map['submittedOn'],
      approvals: Map<String, String>.from(map['approvals']),
      status: map['status'],
    );
  }
}
