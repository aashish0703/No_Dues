import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:no_dues/Util/util.dart';
import 'package:no_dues/models/request.dart';

class RequestService {
  CollectionReference? requestCollection;

  RequestService() {
    requestCollection = FirebaseFirestore.instance.collection("requests");
  }

  // Add request to firestore
  Future<String?> addRequest(RequestModel request) async {
    try {
      DocumentReference docRef = await requestCollection!.add(request.toMap());
      String requestId = docRef.id;
      // Util.requestId = requestId;
      print("[RequestService] Request created with requestId: $requestId");
      return requestId;
    } catch (e) {
      print("[RequestService] Error adding request: $e");
      return null;
    }
  }

  // Update a request
  Future<void> updateApprovalStatus(
      String requestId, String userRole, String status) async {
    try {
      DocumentReference requestRef = requestCollection!.doc(requestId);

      // Update the `approvals` map field for the specific role
      await requestRef.update({
        'approvals.$userRole': status,
      });

      print("Request updated to $status for role: $userRole");
    } catch (e) {
      print("Error updating approval status: $e");
      throw Exception("Failed to update approval status");
    }
  }
}
