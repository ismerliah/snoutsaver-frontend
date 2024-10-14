import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snoutsaver/bloc/dashboard/pocket_bloc.dart';
import 'package:snoutsaver/bloc/setup/setup_bloc.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';
import 'package:snoutsaver/bloc/user/app_bloc.dart';
import 'package:snoutsaver/firebase_options.dart';
import 'package:snoutsaver/pages/pocketdashboard_page.dart';
import 'package:snoutsaver/pages/editprofile_page.dart';
import 'package:snoutsaver/pages/home_page.dart';
import 'package:snoutsaver/pages/profile_page.dart';
import 'package:snoutsaver/pages/setup_page.dart';
import 'package:snoutsaver/pages/signin_page.dart';
import 'package:snoutsaver/pages/signup_page.dart';
import 'package:snoutsaver/pages/today_summary_page.dart';
import 'package:snoutsaver/pages/welcome_page.dart';
import 'package:snoutsaver/repository/setup_repository.dart';

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
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<PocketBloc>(
          create: (context) => PocketBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              bool hasSetupData = snapshot.data!['hasSetupData'];
              bool isTokenValid = snapshot.data!['isTokenValid'];

              if (isTokenValid) {
                if (hasSetupData) {
                  return const DashboardPage();
                } else {
                  return const SetupPage();
                }
              } else {
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
          '/setup': (context) => const SetupPage(),
          '/profile': (context) => const ProfilePage(),
          '/editprofile': (context) => const EditProfilePage(),
          '/dashboard': (context) => const DashboardPage(),
          '/today' : (context) => const TodaySummaryPage(),
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _initializeApp() async {
    const storage = FlutterSecureStorage();
    final setupRepository = SetupRepository();

    String? token = await storage.read(key: 'token');
    String? expiresAt = await storage.read(key: 'expires_at');

    bool isTokenValid = false;
    bool hasSetupData = false;

    if (token != null && expiresAt != null) {
      DateTime expiresAtDateTime = DateTime.parse(expiresAt);
      DateTime now = DateTime.now();

      // Check if the token is still valid
      if (now.isBefore(expiresAtDateTime)) {
        isTokenValid = true;

        // Check if the setup data exists
        hasSetupData = await setupRepository.hasSetupData();
      }
    }

    return {
      'isTokenValid': isTokenValid,
      'hasSetupData': hasSetupData,
    };
  }
}
