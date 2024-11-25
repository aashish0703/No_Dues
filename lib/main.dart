import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:no_dues/pages/department_dash.dart';
import 'package:no_dues/pages/login_department.dart';
import 'package:no_dues/pages/login_student.dart';
import 'package:no_dues/pages/home_page.dart';
import 'package:no_dues/pages/profile_page.dart';
import 'package:no_dues/pages/splash.dart';
import 'firebase_options.dart';
import 'package:no_dues/pages/student_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const Splash(),
        "/login-student": (context) => const LoginStudent(),
        "/login-department": (context) => const LoginDepartment(),
        "/profilepage": (context) => const ProfilePage(),
        "/home": (context) => const HomePage(),
        "/noduesinitiated": (context) => const StudentDashboard(),
        "/department-dash": (context) => const DepartmentDash()
      },
    );
  }
}
