import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:no_dues/Util/util.dart';
import 'package:show_hide_password/show_hide_password.dart';

class LoginStudent extends StatefulWidget {
  const LoginStudent({super.key});

  @override
  _LoginStudentState createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  styleTextField(
    hintText,
    prefixIcon,
    suffixIcon,
  ) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: Colors.purple[50],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.purple,
            width: 1.0,
          )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.purple,
            width: 1.0,
          )),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.purple,
            width: 1.0,
          )),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

        if (mounted) {
          // Snackbar after successful login
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Successful")));

          // Navigate to Student Dashboard
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.of(context).pushReplacementNamed("/profilepage");
        }
        print(
            "User Sign in with : Email: ${emailController.text.trim()} | Password: ${passwordController.text.trim()}");
        String UID = credential.user!.uid;
        Util.UID = UID;
        print("UID : $UID");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Student",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    styleTextField('Email', const Icon(Icons.mail), null),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter email";
                  }
                  if (!value.toString().contains("@") ||
                      !value.toString().contains(".")) {
                    return "Email entered incorrectly : $value";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // TextFormField(
              //   controller: passwordController,
              //   decoration: styleTextField(
              //       'Password',
              //       const Icon(Icons.key_rounded),
              //       const Icon(Icons.remove_red_eye)),
              //   obscureText: true,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Password Cannot be Empty";
              //     }
              //     if (value.length < 6) {
              //       return "Password shoud be 6 characters minimum";
              //     }
              //     return null;
              //   },
              // ),
              ShowHidePassword(passwordField: (bool hidePassword) {
                return TextFormField(
                  obscureText: hidePassword,
                  controller: passwordController,
                  decoration: styleTextField(
                      'password', const Icon(Icons.key_rounded), null),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password Cannot be Empty";
                    }
                    if (value.length < 6) {
                      return "Password shoud be 6 characters minimum";
                    }
                    return null;
                  },

                  ///use the hidePassword status on obscureText to toggle the visibility
                );
              }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("--------OR--------",
                  style: TextStyle(
                    color: Colors.purple,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login-department');
                  },
                  child: const Text("Login as Departmental Authority"))
            ],
          ),
        ),
      ),
    );
  }
}
