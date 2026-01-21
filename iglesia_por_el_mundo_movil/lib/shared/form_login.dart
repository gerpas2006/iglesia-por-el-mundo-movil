import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({super.key,required this.texto,required this.color, this.obscureText = false});

  final String texto;
  final Color color;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Container(
          width: 310,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: texto,
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 16),
                prefixIcon: Icon(Icons.account_circle),
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}