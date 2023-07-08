import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomButton extends StatelessWidget {
  String text;
  void Function()? onPressed;
  CustomButton({
    required this.onPressed,
    required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 30.h),
        elevation: 0,
        backgroundColor: Colors.black
      ),
        child: Text(text, style: TextStyle(fontSize: 14.sp),),
    );
  }
}
