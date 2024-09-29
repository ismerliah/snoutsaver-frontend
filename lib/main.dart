import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snoutsaver/bloc/setup/setup_bloc.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';
import 'package:snoutsaver/firebase_options.dart';
import 'package:snoutsaver/pages/home_page.dart';
import 'package:snoutsaver/pages/setup_page.dart';
import 'package:snoutsaver/pages/signin_page.dart';
import 'package:snoutsaver/pages/signup_page.dart';
// import 'package:snoutsaver/pages/signin_page.dart';
import 'package:snoutsaver/pages/welcome_page.dart';
// import 'package:snoutsaver/pages/home_page.dart';
// import 'package:snoutsaver/pages/splash_page.dart';
//import 'package:snoutsaver/pages/profile_page.dart';

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
      ],
      child: MaterialApp(
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
        initialRoute: '/',
        routes: {
          '/welcome': (context) => const WelcomePage(),
          '/home': (context) => const HomePage(),
          '/signin': (context) => const SigninPage(),
          '/signup': (context) => const SignupPage(),
          '/setup': (context) => SetupPage(),
        },
      ),
    );
  }
}
