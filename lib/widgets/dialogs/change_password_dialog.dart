import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/user/app_bloc.dart';
import 'package:snoutsaver/widgets/dialogs/dialog.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _passwordkey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String? errorMessage;

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          Navigator.of(context).pop();
          CreateDialog().showChangePasswordSuccessDialog(context);
          print('Change Password Success');
        } else if (state is ChangePasswordFailure) {
          setState(() {
            errorMessage = state.error;
            debugPrint('Change Password Error: $errorMessage');
          });
          _passwordkey.currentState!.validate();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.lock,
                  color: Color(0xFF8ACDD7),
                  size: 35,
                ),
              ),
              Text(
                'Change Password',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero, // Remove padding for the close button
                onPressed: () {
                  print('close dialog');
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _passwordkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Current Password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Current Password',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: _currentPasswordController,
                          obscureText: !_isCurrentPasswordVisible,
                          validator: (value) {
                            // current password validation
                            final currentpasswordValidator = MultiValidator([
                              RequiredValidator(errorText: '* Required'),
                            ]);

                            final currentpasswordValidationResult =
                                currentpasswordValidator.call(value);
                            if (currentpasswordValidationResult != null) {
                              return currentpasswordValidationResult;
                            }

                            if (errorMessage ==
                                'Current password is incorrect') {
                              return 'Current password is incorrect';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF90BC),
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _isCurrentPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                                  });
                                },
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // New Password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'New Password',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_isNewPasswordVisible,
                          validator: (value) {
                            // new password validation
                            final newpasswordValidator = MultiValidator([
                              RequiredValidator(errorText: '* Required'),
                              MinLengthValidator(8,
                                  errorText: 'at least 8 characters'),
                              PatternValidator(r'(?=.*[A-Z])',
                                  errorText: 'at least one upper letter'),
                              PatternValidator(r'(?=.*[a-z])',
                                  errorText: 'at least one lower letter'),
                              PatternValidator(r'(?=.*\d)',
                                  errorText: 'at least one digit'),
                              PatternValidator(r'(?=.*[!@#$%^&*])',
                                  errorText: 'at least one special character'),
                            ]);

                            final newpasswordValidationResult =
                                newpasswordValidator.call(value);
                            if (newpasswordValidationResult != null) {
                              return newpasswordValidationResult;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isNewPasswordVisible = !_isNewPasswordVisible;
                                  });
                                },
                              ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                  });
                  if (_passwordkey.currentState!.validate()) {
                    context.read<ProfileBloc>().add(ChangePasswordEvent(
                          current_password: _currentPasswordController.text,
                          new_password: _newPasswordController.text,
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFff90bc),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text(
                      'Save',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
