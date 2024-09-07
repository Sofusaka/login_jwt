import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_jwt/login_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controladores para manejar el texto de los campos
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final LoginService _loginService = Get.find<LoginService>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller1,),
            TextField(controller: _controller2,),
            ElevatedButton(onPressed:(){ _loginService.LoginUser(_controller1.text, _controller2.text);},
             child: const Text('iniciar!!'))
          ],
        ),
      ),
    );
  }
}
