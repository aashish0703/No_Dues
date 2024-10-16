class UserModel {
  String name;
  String email;
  String role; // e.g., Student, HOD, Fee Clerk, etc.
  String? urn; // Optional, Only for students
  String?
      hostel; // Day Scholars can leave it empty and hostelers can fill their hostel number
  String? branch; // Optional, applicable for students
  String? department; // Optional, applicable for HOD, Advisor
  bool isProfileUpdated; // New flag to track profile update status

  UserModel(
      {required this.name,
      required this.email,
      required this.role,
      this.urn,
      this.hostel,
      this.branch,
      this.department,
      this.isProfileUpdated = false});

  // empty User Object
  static UserModel getEmptyUserObject() {
    return UserModel(
        name: "", email: "", role: "", urn: "", department: "NA", hostel: "NA");
  }

  // Convert UserModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'urn': urn,
      'hostel': hostel,
      'branch': branch,
      'department': department,
      'isProfileUpdated': isProfileUpdated,
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      urn: map['urn'] ?? '',
      hostel: map['hostel'] ?? '',
      branch: map['branch'] ?? '',
      department: map['department'] ?? '',
      isProfileUpdated: map['isProfileUpdated'] ?? false, // Handle null value
    );
  }
}
