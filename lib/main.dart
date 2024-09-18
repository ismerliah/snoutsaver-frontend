import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snoutsaver/pages/home_page.dart';
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

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      // home: SplashPage(),
      // home: HomePage(),
      // home: ProfilePage(),
      // home: WelcomePage()
      home: FutureBuilder<String?>(
        future: storage.read(key: 'accesstoken'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            return const HomePage();
            // return ProfilePage();
          } else {
            return const WelcomePage();
            // return SigninPage();
          }
        },
      ),
    );
  }
}

