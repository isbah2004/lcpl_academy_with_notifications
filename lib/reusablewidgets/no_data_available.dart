import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcpl_academy/utils/constants.dart';

class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Constants.emptyLogo,
            height: 100,
          ),
          const SizedBox(
            height: 5,
          ),
          Text('No data available',
              style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
