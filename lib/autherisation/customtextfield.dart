import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: HexColor("dbd8e3")),
            cursorColor: HexColor("dbd8e3"),
            decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
                color: HexColor("dbd8e3"),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            validator: validator,
            onSaved: onSaved,
            obscureText: obscureText,
            keyboardType: keyboardType,
          ),
        ),
      ),
    );
  }
}
