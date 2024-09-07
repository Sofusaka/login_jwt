import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_jwt/homepage.dart';
import 'package:login_jwt/login.dart';
import 'package:login_jwt/login_service.dart';

class LoginInterface extends StatefulWidget {
  @override
  _LoginInterfaceState createState() => _LoginInterfaceState();
}

class _LoginInterfaceState extends State<LoginInterface> {
  final LoginService _loginService = Get.find<LoginService>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await _loginService.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      initialRoute: '/login', // Define la ruta inicial según el estado del login
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/Homepage', page: () => Homepage()),
      ],
    );
  }
}
