import 'package:cloud_firestore/cloud_firestore.dart';
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
}
