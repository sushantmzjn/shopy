import 'package:flutter/material.dart';

class SnackShow {
  static showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      duration: Duration(seconds: 2),
      content: Text(message,style: TextStyle(color: Colors.white),),
    ));
  }

  static showFailure(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Text(message, style: TextStyle(color: Colors.white)),
    ));
  }
}
