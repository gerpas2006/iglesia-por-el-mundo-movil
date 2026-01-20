import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({super.key,required this.texto,required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(texto, style: TextStyle(fontSize: 20),)
              ],
            ),
          ],
        ),
        ),
    );
  }
}