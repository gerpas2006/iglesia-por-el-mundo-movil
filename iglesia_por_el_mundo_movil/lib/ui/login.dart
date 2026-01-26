import 'package:flutter/material.dart';
import 'package:iglesia_por_el_mundo_movil/shared/form_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        color: const Color(0xFFF1F3FF),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              const Text('Iglesia por el Mundo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
              const SizedBox(height: 50),
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
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Iniciar Sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
