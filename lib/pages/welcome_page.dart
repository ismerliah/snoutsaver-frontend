import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';
import 'package:snoutsaver/repository/setup_repository.dart';
import 'package:snoutsaver/widgets/dialogs/dialog.dart';
import 'package:snoutsaver/widgets/loading.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  final storage = const FlutterSecureStorage();

  void _checkSetupData(BuildContext context) async {
    final setupRepository = SetupRepository();
    final hasSetupData = await setupRepository.hasSetupData();
    if (hasSetupData) {
      Navigator.pushNamed(context, '/dashboard');
    } else {
      Navigator.pushNamed(context, '/setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // sign in with google
          if (state is SigninwithGoogleSuccess) {
            _checkSetupData(context);
          } else if (state is SigninwithGoogleFailure) {
            debugPrint('Sign in with Google Failure: ${state.error}');
            CreateDialog().showErrorDialog(context, 'Failed to sign in with Google. Please try again.');
          } else if (state is SigninwithGoogleLoading) {
            debugPrint('Sign in with Google Loading...');
          }
        },
        builder: (context, state) {
          if (state is SigninwithGoogleLoading || state is SigninLoading) {
            return const Loading();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //LOGO
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 414,
                    height: 177,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      //SIGN IN BUTTON
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signin');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFff90bc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              
                            ),
                            child: Text(
                            'Sign in',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          ),
                        ),
                      ),
                      
                      //SIGN UP BUTTON
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFff90bc),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              
                            ),
                            child: Text(
                            'Create an account',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          ),
                        ),
                      ),
            
                      //or
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                  child: Divider(
                                      color: Colors.white,
                                      thickness: 2,
                                      endIndent: 10)),
                              Text(
                                'or',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                  indent: 10,
                              )),
                            ],
                          ),
                        ),
                      ),
            
                      // SIGN IN WITH GOOGLE BUTTON
                      ElevatedButton.icon(
                        icon: Image.asset('assets/images/google-icon.png', height: 24),
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(SigninwithGoogleEvent());
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        label: Text(
                          'Sign in with Google',
                          style: GoogleFonts.outfit(
                            textStyle:
                                const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}