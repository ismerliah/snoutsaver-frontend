import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/user/app_bloc.dart';
import 'package:snoutsaver/repository/user_repository.dart';
import 'package:snoutsaver/widgets/dialogs/dialog.dart';
import 'package:snoutsaver/widgets/dialogs/select_profile_dialog.dart';
import 'package:snoutsaver/widgets/loading.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  String? imgUrl;
  String? errorMessage;
  bool _isLoading = false; // Loading state

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    try {
      final user = await UserRepository().fetchUserDetails();
      // final token = await storage.read(key: "token");
      // print('token: $token');

      setState(() {
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _firstnameController.text = user.firstName ?? '';
        _lastnameController.text = user.lastName ?? '';
        imgUrl = user.profilePicture ?? '';
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _usernameController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 10),
          icon: const Icon(Icons.arrow_back_ios, size: 30),
          onPressed: () {
            Navigator.pop(context, imgUrl);
          },
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(fontSize: 35),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFffc0d9),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            CreateDialog().showEditProfileSuccessDialog(context);
            print('User updated successfully');
          } else if (state is UpdateUserFailure) {
            setState(() {
              errorMessage = state.error;
              debugPrint('Edit Profile Error: $errorMessage');
            });
            _formkey.currentState!.validate();
          }
        },
        builder: (context, state) {
          if (state is UpdateUserLoading) {
            return const Loading();
          } else {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // EDIT PROFILE PICTURE
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 5, color: const Color(0xFFffca4d)),
                            ),
                            child: ClipOval(
                              child: imgUrl != null && imgUrl!.isNotEmpty
                                  ? Image.network(
                                      imgUrl!,
                                      fit: BoxFit.fitHeight,
                                      loadingBuilder: (_, child, chunkEvent) {
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: child,
                                        );
                                      },
                                    )
                                  : const Icon(Icons.person,
                                      size: 120, color: Color(0xFFFFD200)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                // Handle profile picture selection
                                final result = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const SelectProfileDialog();
                                  },
                                );
                                if (result != null) {
                                  setState(() {
                                    imgUrl = result;
                                  });
                                }
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: const Icon(Icons.settings, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // FORM
                    Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFFF90BC),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Username
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Username',
                                      style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF90BC),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        // Username validation
                                        final usernameValidator =
                                            MultiValidator([
                                          RequiredValidator(
                                              errorText: '* Required'),
                                        ]);

                                        final usernameValidationResult =
                                            usernameValidator.call(value);
                                        if (usernameValidationResult != null) {
                                          return usernameValidationResult;
                                        }

                                        if (errorMessage ==
                                            'Username already exists') {
                                          return 'Username already exists';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              // Email
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Email',
                                      style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF90BC),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        // Email validation
                                        final emailValidator = MultiValidator([
                                          RequiredValidator(
                                              errorText: '* Required'),
                                          EmailValidator(
                                              errorText:
                                                  'Enter a valid email address'),
                                        ]);

                                        final emailValidationResult =
                                            emailValidator.call(value);
                                        if (emailValidationResult != null) {
                                          return emailValidationResult;
                                        }

                                        if (errorMessage ==
                                            'Email already exists') {
                                          return 'Email already exists';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              // First Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'First Name',
                                      style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      controller: _firstnameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF90BC),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Last Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Last Name',
                                      style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      controller: _lastnameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFFF90BC),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Save Button
                              const SizedBox(height: 20),
                              _isLoading // Show loading indicator if saving
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFFFF90BC),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              errorMessage = null;
                                            });
                                            if (_formkey.currentState!
                                                .validate()) {
                                              context.read<ProfileBloc>().add(
                                                  UpdateUserDetailEvent(
                                                      email:
                                                          _emailController.text,
                                                      username:
                                                          _usernameController
                                                              .text,
                                                      first_name:
                                                          _firstnameController
                                                              .text,
                                                      last_name:
                                                          _lastnameController
                                                              .text,
                                                      profile_picture:
                                                          imgUrl!));
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(12),
                                            backgroundColor:
                                                const Color(0xFFff90bc),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            'Save Change',
                                            style: GoogleFonts.outfit(
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
