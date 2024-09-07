import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_jwt/login_service.dart';
import 'package:login_jwt/routes.dart';


void main() {
 
  Get.put(LoginService());

  runApp(LoginInterface());
}

