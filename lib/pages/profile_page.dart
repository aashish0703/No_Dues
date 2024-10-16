import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:no_dues/Util/util.dart';
import 'package:no_dues/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  UserModel user = UserModel.getEmptyUserObject();

  bool isProfileUpdated = false; //Initialize to false

  @override
  void initState() {
    super.initState();

    fetchUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // This ensures the dialog shows after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text(
                "Update your profile carefully. You cannot change the details later on."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  fetchUserProfile() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(Util.UID)
          .get();
      if (doc.exists) {
        setState(() {
          user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          isProfileUpdated = user.isProfileUpdated;
        });
      }

      // if (mounted) {
      //   // Navigate to NoDues initiation page if profile is updated
      //   if (isProfileUpdated) {
      //     Navigator.of(context).pushReplacementNamed('/noduesinitiated');
      //   }
      // }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  saveUserInFireStore() {
    formKey.currentState!.save();
    user.isProfileUpdated = true; // Set profile as updated
    print("User details: ${user.toMap().toString()}");

    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(Util.UID)
          .set(user.toMap())
          .then((value) {
        print("User data ${user.toMap().toString()} Saved in Firestore");
        // show snackbar   or toast
        // Navigator.of(context).pushReplacementNamed("/home");
        const message = SnackBar(content: Text("Profile Saved/Updated"));
        ScaffoldMessenger.of(context).showSnackBar(message);
        setState(() {
          isProfileUpdated = true; // Update UI after save
        });
      });
    } catch (e) {
      print("Exception while saving user profile");
      print(e);
    }
  }

  styleTextField(hintText, label) {
    return InputDecoration(
      hintText: hintText,
      label: label,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.purple, width: 1.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.purple, width: 1.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.purple, width: 1.0)),
    );
  }

  Widget _buildEditableProfile() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  "Update Your Profile",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration:
                      styleTextField("Enter your name", const Text("Name")),
                  onSaved: (newValue) {
                    user.name = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration:
                      styleTextField('Enter your email', const Text("Email")),
                  onSaved: (newValue) {
                    user.email = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: styleTextField(
                      "Enter your role eg: student, clerk, HOD, etc.",
                      const Text("Role")),
                  onSaved: (newValue) {
                    user.role = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration:
                      styleTextField("Enter your URN", const Text("URN")),
                  initialValue: user.urn,
                  onSaved: (newValue) {
                    user.urn = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration:
                      styleTextField("Enter your branch", const Text("Branch")),
                  onSaved: (newValue) {
                    user.branch = newValue!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    TextFormField(
                      decoration: styleTextField(
                          "Enter your department", const Text("Department")),
                      initialValue: user.department,
                      onSaved: (newValue) {
                        user.department = newValue!;
                      },
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Leave it empty if you are a Student")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    TextFormField(
                      decoration: styleTextField("Enter your hostel number",
                          const Text("Hostel Number")),
                      initialValue: user.hostel,
                      onSaved: (newValue) {
                        user.hostel = newValue!;
                      },
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Leave it empty if you are a day scholar")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: saveUserInFireStore,
                    child: const Text("Save Profile"))
              ],
            )),
      ),
    );
  }

  Widget _buildReadOnlyProfile() {
    return Center(
      child: Column(
        children: [
          Text("Name: ${user.name}"),
          Text("Email: ${user.email}"),
          Text("Role: ${user.role}"),
          Text("URN: ${user.urn}"),
          Text("Branch: ${user.branch}"),
          Text(
              "Hostel: ${user.hostel!.isNotEmpty ? user.hostel : 'Day Scholar'}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isProfileUpdated) {
      // Redirect the user to the NoDues initiation page
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed('/home');
      });

      // // Return CircularProgressIndicator while redirecting
      // return const Center(
      //   child: CircularProgressIndicator(),
      // );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
        centerTitle: true,
      ),
      // body: _buildEditableProfile(),
      body:
          isProfileUpdated ? _buildReadOnlyProfile() : _buildEditableProfile(),
    );
  }
}
