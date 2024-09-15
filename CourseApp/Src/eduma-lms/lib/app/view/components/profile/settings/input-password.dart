import 'dart:ui';
import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  InputPassword({required this.controller});

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool showPassword = false; // Moved outside build

  @override
  Widget build(BuildContext context) {
    var screenWidth =
        (window.physicalSize.shortestSide / window.devicePixelRatio);
    return Container(
      width: screenWidth - 32,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFF949494),
              ),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 20, right: 20, top: -10, bottom: 0),
                border: InputBorder.none,
              ),
              obscureText: !showPassword,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              showPassword = !showPassword;
            }),
            child: Container(
              width: 50,
              alignment: Alignment.center,
              child: Icon(
                showPassword == false ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFFD2D2D2),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
