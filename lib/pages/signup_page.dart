import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:snoutsaver/google_auth.dart';
import 'package:snoutsaver/pages/home_page.dart';
import 'package:snoutsaver/pages/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String errorMessage = '';

  Future<void> _signUp() async {
    setState(() {
      errorMessage = '';
    });
    if (_formkey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/users/create"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "username": _username.text,
          "email": _email.text,
          "password": _password.text,
          "confirm_password": _confirmPassword.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/signin');
      } else if (response.statusCode == 400) {
        // Handle the error response
        final Map<String, dynamic> result = jsonDecode(response.body);

        setState(() {
          if (result['detail'] == "Username already exists") {
            errorMessage = "Username already exists";
          } else if (result['detail'] == "Email already exists") {
            errorMessage = "Email already exists";
          } else if (result['detail'] == "Passwords do not match") {
            errorMessage = "Passwords do not match";
          }
        });

        // Re-validate form to display error messages
        _formkey.currentState!.validate();
      } else {
        // Handle other status codes (e.g., 500 or network error)
        setState(() {
          errorMessage = "Failed to sign up. Please try again later.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: Center(
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
                          'Sign up',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '* Required';
                        } else if (errorMessage == 'Username already exists') {
                          return 'Username already exists';
                        }
                        return null;
                      },
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

                  // Email
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) {
                        // Email validation
                        final emailValidator = MultiValidator([
                          RequiredValidator(errorText: '* Required'),
                          EmailValidator(
                              errorText: 'Enter a valid email address'),
                        ]);

                        final emailValidationResult =
                            emailValidator.call(value);
                        if (emailValidationResult != null) {
                          return emailValidationResult;
                        }

                        if (errorMessage == 'Email already exists') {
                          return 'Email already exists';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                          Icons.email,
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
                      validator: (value) {
                        // Password validation
                        final passwordValidator = MultiValidator([
                          RequiredValidator(errorText: '* Required'),
                          MinLengthValidator(8,
                              errorText:
                                  'Password must be at least 8 characters'),
                        ]);

                        final passwordValidationResult =
                            passwordValidator.call(value);
                        if (passwordValidationResult != null) {
                          return passwordValidationResult;
                        }
                        return null;
                      },
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

                  // Confirm Password
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _confirmPassword,
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        // Password validation
                        final passwordValidator = MultiValidator([
                          RequiredValidator(errorText: '* Required'),
                          MinLengthValidator(8,
                              errorText:
                                  'Password must be at least 8 characters'),
                        ]);

                        final passwordValidationResult =
                            passwordValidator.call(value);
                        if (passwordValidationResult != null) {
                          return passwordValidationResult;
                        } else if (errorMessage == 'Passwords do not match') {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
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
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Sign up button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFff90bc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign up',
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
                    icon: Image.asset('assets/images/google-icon.png', height: 24),
                    onPressed: () async{
                      final user = await GoogleAuth.signinWithGoogle();
                      if (user != null && mounted) {
                        print(user);
                        Navigator.pushNamed(context, '/home');
                      } else {
                        print('Failed to sign in with Google');
                      }
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

                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account!",
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 241, 77, 143)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
