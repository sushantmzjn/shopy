import 'package:flutter/material.dart';
class CustomTextForm extends StatelessWidget {
  String labelText;
  TextInputType keyboardType;
  String? Function(String?)? validator;
  void Function(String)? onChanged;
  TextEditingController? controller;
  bool obscureText;
  Widget? suffixIcon;

  CustomTextForm({super.key,
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    this.onChanged,
    required this.controller,
    required this.obscureText,
    this.suffixIcon
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: suffixIcon,
            floatingLabelStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.black),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: Colors.black)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.white)
          )
        ),
      ),
    );
  }
}
