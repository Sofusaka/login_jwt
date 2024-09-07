import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:login_jwt/db.dart';
import 'package:login_jwt/login_service.dart';

class ProductoSingle extends StatefulWidget {
  final int id;
  final String img;
  final String nombre;
  final String calificacion;
  final String vendedor;

  const ProductoSingle({
    required this.id,
    required this.calificacion,
    required this.vendedor,
    required this.img,
    required this.nombre,
    super.key,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
  @override
  _ProductoSingleState createState() => _ProductoSingleState();
}

class _ProductoSingleState extends State<ProductoSingle> {
  bool _isFavorite = false; // Estado para controlar si el producto es favorito
  final LoginService _loginService = Get.find<LoginService>();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Al iniciar, verificar si el producto es favorito
  }

  // Verificar si el producto ya es favorito



Future<void> _checkIfFavorite() async {
  try {
    String apiUrl = '192.168.0.16';
    String sUrl = "http://$apiUrl:3000/favoritos/${widget.id}";

    String? sToken = await _loginService.getUserData();
    Map<String, dynamic> TokenFinal = jsonDecode(sToken!);
    String? token = TokenFinal['token'];

    final response = await http.get(
      Uri.parse(sUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      setState(() {
        // Si la respuesta contiene el error 'no hay', cambiar a false
        if (responseData.containsKey('error') && responseData['error'] == 'no hay') {
          _isFavorite = false; // No está en favoritos
        } else {
          _isFavorite = true; // Está en favoritos
        }
      });
    }
  } catch (e) {
    print('Error al verificar favoritos: $e');
  }
}




  // Función para agregar a favoritos
  Future<void> _addToFavorites() async {
    try {
      String apiUrl = '192.168.0.16';
      String sUrl = "http://$apiUrl:3000/addfavoritos";

      String? sToken = await _loginService.getUserData();
      Map<String, dynamic> TokenFinal = jsonDecode(sToken!);
      String? token = TokenFinal['token'];

      final response = await http.post(
        Uri.parse(sUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'id_producto': widget.id, // ID del producto
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isFavorite = true; // Marcar como favorito
        });
        print('Producto añadido a favoritos');
      } else {
        print('Error al añadir a favoritos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

 
  Future<void> _removeFromFavorites() async {
    try {
      String apiUrl = '192.168.0.16';
      String sUrl = "http://$apiUrl:3000/deletefavoritos";

      String? sToken = await _loginService.getUserData();
      Map<String, dynamic> TokenFinal = jsonDecode(sToken!);
      String? token = TokenFinal['token'];

      final response = await http.delete(
        Uri.parse(sUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'id_producto': widget.id, // ID del producto
        })
      );

      if (response.statusCode == 200) {
        setState(() {
          _isFavorite = false; // Eliminar de favoritos
        });
        print('Producto eliminado de favoritos');
      } else {
        print('Error al eliminar de favoritos');
      }
    } catch (e) {
      print('Error: $e');
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 150, 156, 167)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Image(
                  image: NetworkImage(widget.img),
                  height: 66,
                  width: 66,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.nombre),
                Text(widget.calificacion),
                Text(widget.vendedor),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (_isFavorite) {
                DB.eliminar(widget.id);
                DB.obtenerFavoritos(); // Eliminar de favoritos
                _removeFromFavorites(); // Eliminar de favoritos
              } else {
                DB.insertar(widget.id, widget.nombre);
                DB.obtenerFavoritos(); // Agregar a favoritos
                _addToFavorites(); // Agregar a favoritos
              }
            },
          ),
        ],
      ),
    );
  }
}
