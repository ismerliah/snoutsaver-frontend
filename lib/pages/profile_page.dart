import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8ACDD7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/default_profile_picture.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Handle camera button click
                      print('Camera button clicked');
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Icon(Icons.camera, size: 15),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Buttons
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), backgroundColor: const Color(0xFFFF90BC),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    // Handle edit profile button click
                    print('Edit profile button clicked');
                  },
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), backgroundColor: const Color(0xFFFF90BC),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    // Handle change password button click
                    print('Change password button clicked');
                  },
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), backgroundColor: const Color(0xFFFF90BC),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    // Handle sign out button click
                    print('Sign out button clicked');
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}