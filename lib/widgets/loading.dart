import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: CircularProgressIndicator(
              color: Color(0xFFff90bc),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                'Loading...',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 92, 92, 92),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
