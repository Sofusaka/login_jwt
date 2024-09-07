
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_jwt/homepage.dart';
import 'package:login_jwt/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class LoginService extends GetxController{

Future<void> LoginUser(String email, String password) async{
  
 print("Entró a Login");

  String apiUrl ='192.168.0.16';

  final response = await http.post(
      Uri.parse('http://$apiUrl:3000/login'),
      body: {'email': email, 'password': password},
    );
  print("hizo get");
  print(response.body);
  if (response.statusCode == 200) {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();


      await prefs.setString('JWT_token', response.body);

      print('Login successful, user data saved.');
       Get.offNamed('/Homepage');



    } else {
      print('Login failed: ${response.statusCode}');
    }
}
 


Future<String?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('JWT_token'));
  return prefs.getString('JWT_token');
}

Future<void> checkLoginStatus() async {
  String? userData = await getUserData();
  if (userData != null) {
    //sesion iniciada
    print('User data: $userData');
    
    Get.to(Homepage());
  } else {
    Get.to(Login());
    print('No user data found.');
  }
}


 Future<String?> getEncryptedName() async {
    String? token = await getUserData();
    if (token != null && JwtDecoder.isExpired(token) == false) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['email']; 
    }
    return null;
  }


  Future<void> logoutUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('JWT_token'); // Eliminar el JWT del almacenamiento
  print('JWT eliminado, usuario desconectado.');
  
  // Redirigir a la pantalla de login
  Get.offAll(Login()); // Navegar a la pantalla de login y limpiar el historial de navegación
}






}
