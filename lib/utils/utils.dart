import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcpl_academy/theme/theme.dart';

class Utils {
  static void changeFocus(
      {required FocusNode currentFocus,
      required FocusNode nextFocus,
      required BuildContext context}) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage({required String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppTheme.greyColor,
        textColor: AppTheme.darkGrey,
        fontSize: 16.0);
  }
}
