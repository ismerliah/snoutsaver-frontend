import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:snoutsaver/pages/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Future<void> _signIn() async {
    if (_formkey.currentState!.validate()) {
      var dio = Dio();

      var response = await dio.get('http://localhost:8000/users/');

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const SignupPage(),
        ));
      } else {
        print('Failed to load data');
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
                          'Sign in',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
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
                        MinLengthValidator(8,
                            errorText: 'Password must be at least 8 characters'),
                      ]).call,
                      // validationRules: {
                      //   UppercaseValidationRule(),
                      //   LowercaseValidationRule(),
                      //   DigitValidationRule(),
                      //   SpecialCharacterValidationRule(),
                      //   MinCharactersValidationRule(8),
                      // },
                      // strengthIndicatorBuilder: (strength) {
                      //   return StepProgressIndicator(
                      //     totalSteps: 8,
                      //     currentStep: getStep(strength),
                      //     // selectedColor: getColor(strength)!,
                      //     unselectedColor: Colors.grey[300]!,
                      //   );
                      // },
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
                  // PasswordValidatedFields(
                  //   inActiveIcon: Icons.check_circle,
                  //   activeIcon: Icons.check_circle,
                  //   inActiveRequirementColor: Colors.grey,
                  //   activeRequirementColor: Colors.green,
                  //   inputDecoration: InputDecoration(
                  //     hintText: 'Password',
                  //     hintStyle: const TextStyle(
                  //       fontSize: 16,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     fillColor: Colors.white,
                  //     filled: true,
                  //     focusedBorder: const OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       borderSide: BorderSide(
                  //         color: Color(0xFFff90bc),
                  //         width: 2,
                  //       ),
                  //     ),
                  //     prefixIcon: const Icon(
                  //       Icons.lock,
                  //     ),
                  //     suffixIcon: const Icon(
                  //       Icons.visibility_off,
                  //     ),
                  //   ),
                  // ),
              
                  // Sign in button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signIn,
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
                          textStyle: const TextStyle(
                              fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                          ));
                        },
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 241, 77, 143)),
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
      ),
    );
  }
}
