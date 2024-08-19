import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';

class ReusableButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool? loading;
  const ReusableButton(
      {super.key, required this.title, required this.onTap, this.loading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.primaryColor,
        ),
        child: loading ?? false
            ? Lottie.asset(Constants.loadingAnimation)
            : Text(
                title,
                style: GoogleFonts.ubuntu(
                    fontSize: 19, color: AppTheme.whiteColor),
              ),
      ),
    );
  }
}
