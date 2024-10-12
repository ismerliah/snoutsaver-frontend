import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snoutsaver/bloc/setup/setup_bloc.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';
import 'package:snoutsaver/bloc/user/app_bloc.dart';
import 'package:snoutsaver/firebase_options.dart';
import 'package:snoutsaver/pages/editprofile_page.dart';
import 'package:snoutsaver/pages/home_page.dart';
import 'package:snoutsaver/pages/profile_page.dart';
import 'package:snoutsaver/pages/setup_page.dart';
import 'package:snoutsaver/pages/signin_page.dart';
import 'package:snoutsaver/pages/signup_page.dart';
import 'package:snoutsaver/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<SetupBloc>(
          create: (context) => SetupBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //debugShowCheckedModeBanner: false,
        // home: SplashPage(),
        // home: HomePage(),
        // home: ProfilePage(),
        // home: WelcomePage()
        home: FutureBuilder(
          future: Future.wait([
            storage.read(key: 'token'),
            storage.read(key: 'expires_at'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              String? token = snapshot.data![0];
              String? expiresAt = snapshot.data![1];

              if (token != null && expiresAt != null) {
                DateTime expiresAtDateTime = DateTime.parse(expiresAt);
                DateTime now = DateTime.now();
                if (now.isAfter(expiresAtDateTime)) {
                  // Token has expired, log out the user
                  return const WelcomePage();
                } else {
                  // Token is still valid
                  return const ProfilePage(); //Change later
                }
              } else {
                // No token or expires_at value found
                return const WelcomePage();
              }
            } else {
              return const WelcomePage();
            }
          },
        ),
        initialRoute: '/',
        routes: {
          '/welcome': (context) => const WelcomePage(),
          '/home': (context) => const HomePage(),
          '/signin': (context) => const SigninPage(),
          '/signup': (context) => const SignupPage(),
          '/setup': (context) => SetupPage(),
          '/profile': (context) => const ProfilePage(),
          '/editprofile': (context) => const EditProfilePage(),
        },
      ),
    );
  }
}
