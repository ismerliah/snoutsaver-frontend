import 'package:flutter/material.dart';
// import 'package:snoutsaver/pages/signin_page.dart';
import 'package:snoutsaver/pages/welcome_page.dart';
// import 'package:snoutsaver/pages/home_page.dart';
// import 'package:snoutsaver/pages/splash_page.dart';
//import 'package:snoutsaver/pages/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //debugShowCheckedModeBanner: false,
      // home: SplashPage(),
      // home: HomePage(),
      // home: ProfilePage(),
      home: WelcomePage()
    );
  }
}

