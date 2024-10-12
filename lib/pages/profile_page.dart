import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/widgets/dialogs/change_password_dialog.dart';
import 'package:snoutsaver/widgets/dialogs/dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imgUrl;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    imgUrl = await storage.read(key: 'profilepic');
    print("imgUrl: $imgUrl");
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFffc0d9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Profile Picture
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 10, color: const Color(0xFFffca4d)),
                ),
                child: ClipOval(
                  child: 
                  imgUrl != null && imgUrl!.isNotEmpty
                      ? Image.network(
                          imgUrl!,
                        )
                      : const Icon(Icons.person,
                          size: 170, color: Color(0xFFffca4d)),
                ),
              ),
            ),

            // BUTTONS
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EDIT PROFILE BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFFF90BC),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/editprofile');
                      // Handle edit profile button click
                      print('Edit profile button clicked');
                    },
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // CHANGE PASSWORD BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFFF90BC),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangePasswordDialog();
                        },
                      );
                      // Handle change password button click
                      print('Change password button clicked');
                    },
                    child: Text(
                      'Change Password',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // LINE DIVIDER
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Expanded(
                        child: Divider(
                      color: Color(0xFF7f7f7f),
                      thickness: 3,
                    )),
                  ),
                ),

                // SAVING INFORMATION BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFFF90BC),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      // Handle sign out button click
                      print('Saving information button clicked');
                    },
                    child: Text(
                      'Saving information',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // NOTIFICATION BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFFF90BC),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      // Handle sign out button click
                      print('Notification clicked');
                    },
                    child: Text(
                      'Notification',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // LINE DIVIDER
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Expanded(
                        child: Divider(
                      color: Color(0xFF7f7f7f),
                      thickness: 3,
                    )),
                  ),
                ),

                // SIGN OUT BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFFF90BC),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      CreateDialog().showSignoutDialog(context);
                      print('Sign out button clicked');
                    },
                    child: Text(
                      'Sign Out',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
