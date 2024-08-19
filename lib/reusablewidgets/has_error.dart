import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcpl_academy/utils/constants.dart';

class HasError extends StatelessWidget {
  const HasError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Constants.errorLogo,
            height: 100,
          ),
          const SizedBox(
            height: 5,
          ),
          Text('Some error occured',
              style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
