import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';

class CreateDialog {
  // Error Dialog
  Future<void> showErrorDialog(BuildContext context, String text) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Error',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            content: Text(
              text,
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  // Signout Dialog
  Future<void> showSignoutDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Sign out',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(SignOutEvent());
                        Navigator.pushNamed(context, '/welcome');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5757),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Sign out',
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  // edit profile success
  Future<void> showEditProfileSuccessDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Icon( Icons.check_circle_rounded, color: Colors.green, size: 50),
            ),
            content: Text(
              'Profile has been updated successfully.',
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

}
