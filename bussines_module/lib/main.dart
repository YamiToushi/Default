import 'package:bussines_module/frontend/admin/pages/home_page.dart';
import 'package:bussines_module/frontend/worker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bussines_module/frontend/auth/login.dart';
import 'package:bussines_module/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD9U_h_FDPOCJGFfXVMVZV3aTzq1LwFFAM",
      authDomain: "bussinesmodule.firebaseapp.com",
      projectId: "bussinesmodule",
      storageBucket: "bussinesmodule.appspot.com",
      messagingSenderId: "302387180633",
      appId: "1:302387180633:android:2f53cd598b0b45eba4ed48",
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userType = prefs.getString('userType');

  Widget home = const Login();
  if (userType != null) {
    if (userType == 'admin') {
      home = const AdminHomePage();
    } else if (userType == 'worker') {
      home =  const WorkerHomePage();
    }
  }

  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Business Automation App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: home,
    );
  }
}
