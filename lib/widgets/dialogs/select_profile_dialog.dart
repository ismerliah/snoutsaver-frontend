import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/user/app_bloc.dart';
import 'package:snoutsaver/repository/profilepic_repository.dart';
import 'package:snoutsaver/widgets/loading.dart';

class SelectProfileDialog extends StatefulWidget {
  const SelectProfileDialog({super.key});

  @override
  State<SelectProfileDialog> createState() => _SelectProfileDialogState();
}

class _SelectProfileDialogState extends State<SelectProfileDialog> {
  // late Future<List<String>> _picturesFuture;
  String? _selectedPicture;
  late final Future<List<String>> _picturesFuture =
      ProfilePicRepository().getAllPictures();

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is UpdatePictureSuccess) {
          print('update picture success');
          Navigator.pop(context, _selectedPicture);
        } else if (state is UpdatePictureFailure) {
          print('update picture failure');
        }
      },
      builder: (context, state) {
        if (state is UpdatePictureLoading) {
          return const Loading();
        } else {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(8),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF8ACDD7),
                    size: 35,
                  ),
                ),
                Text(
                  'Profile Picture',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  padding:
                      EdgeInsets.zero, // Remove padding for the close button
                  onPressed: () {
                    print('close dialog');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(5),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: double.maxFinite,
                  height: 350,
                  child: FutureBuilder<List<String>>(
                    future: _picturesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  _selectedPicture == snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPicture = snapshot.data![index];
                                  });
                                  print(
                                      'Selected image: ${snapshot.data![index]}');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFFF90BC)
                                            : const Color(0xFF7F7F7F),
                                        width: 3,
                                      )),
                                  child: Image.network(
                                    snapshot.data![index],
                                  ),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFff90bc),
                            strokeWidth: 5,
                          ),
                        );
                      }
                    },
                  )),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: (_selectedPicture != null)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFff90bc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<ProfileBloc>()
                              .add(UpdateProfilePictureEvent(
                                profile_picture: _selectedPicture!,
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Done',
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFff90bc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Done',
                              style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}
