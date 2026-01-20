import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/shared/form_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        color: const Color.fromARGB(104, 187, 187, 187),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormLogin(
                  texto: 'Usuario',
                  color: const Color.fromARGB(104, 179, 178, 178),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormLogin(
                  texto: 'Contraseña',
                  color: const Color.fromARGB(104, 179, 178, 178),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
