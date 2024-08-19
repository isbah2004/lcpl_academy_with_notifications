import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcpl_academy/theme/theme.dart';

class ReusableTextField extends StatelessWidget {
  final String hintText;
  final double? padding;
  final Widget? prefix, suffix;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputType keyboardType;
  final bool? obscureText;
  final int? maxLines;
  const ReusableTextField(
      {super.key,
      this.prefix,
      this.suffix,
      this.padding,
      required this.hintText,
      required this.controller,
      this.focusNode,
      this.validator,
      this.onFieldSubmitted,
      required this.keyboardType,
      this.obscureText,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      obscureText: obscureText ?? false,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      focusNode: focusNode,
      cursorColor: AppTheme.cursorColor,
      decoration: InputDecoration(
        hintStyle: GoogleFonts.ubuntu(),
        hintText: hintText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        fillColor: AppTheme.accentColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.cursorColor),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
      ),
    );
  }
}
