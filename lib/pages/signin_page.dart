import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:snoutsaver/pages/signup_page.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';
import 'package:snoutsaver/widgets/dialog.dart';
import 'package:snoutsaver/widgets/loading.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // Sign in
          if (state is SigninSuccess) {
            debugPrint('Signin Success');
            Navigator.pushNamed(context, '/home');

          } else if (state is SigninFailure) {
            debugPrint("Signin Error: ${state.error}");
            CreateDialog().showErrorDialog(context, 'Invalid username or password');
          
          } else if (state is SigninLoading) {
            debugPrint('Signin Loading...');

          // Sign in with Google
          } else if (state is SigninwithGoogleSuccess) {
            debugPrint('Sign in with Google Success');
            Navigator.pushNamed(context, '/home');

          } else if (state is SigninwithGoogleFailure) {
            debugPrint('Sign in with Google Failure: ${state.error}');
            CreateDialog().showErrorDialog(context, 'Failed to sign in with Google. Please try again.');

          
          } else if (state is SigninwithGoogleLoading) {
            debugPrint('Sign in with Google Loading...');
          }
        },
        builder: (context, state) {
          if (state is SigninLoading || state is SigninwithGoogleLoading) {
            return const Loading();
          } else {
            return Center(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Sign in
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign in',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                      fontSize: 35, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Username
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _username,
                            validator: MultiValidator([
                              RequiredValidator(errorText: '* Required'),
                            ]).call,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFFff90bc),
                                  width: 2,
                                ),
                              ),
                              focusColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                        ),

                        // Password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _password,
                            obscureText: !_isPasswordVisible,
                            validator: MultiValidator([
                              RequiredValidator(errorText: '* Required'),
                            ]).call,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Color(0xFFff90bc),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        // Sign in button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  context
                                      .read<AuthenticationBloc>()
                                      .add(SigninEvent(
                                        username: _username.text,
                                        password: _password.text,
                                      ));
                                }
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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

                        // Sign in with Google
                        ElevatedButton.icon(
                          icon: Image.asset('assets/images/google-icon.png',
                              height: 24),
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
                              textStyle: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),

                        // Forgot password
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     TextButton(
                        //       onPressed: () {},
                        //       child: Text(
                        //         'Forgot password?',
                        //         style: GoogleFonts.outfit(
                        //           textStyle: const TextStyle(
                        //               fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // New user? Sign up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Sign up',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 241, 77, 143)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
