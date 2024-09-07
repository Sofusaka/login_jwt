import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_jwt/login_service.dart';
import 'package:http/http.dart' as http;
import 'package:login_jwt/producto_single.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _showFavorites = false;
  int _crossAxisCount = 2;
  final LoginService _loginService = Get.find<LoginService>();
  double _aspectRatio = 1.5;
  ViewType _viewType = ViewType.grid;

  // Función genérica para obtener productos
  Future<List<ProductoSingle>> _fetchProductos(String endpoint) async {
    try {
      String apiUrl = '192.168.0.16';
      String sUrl = "http://$apiUrl:3000/$endpoint";

      String? sToken = await _loginService.getUserData();
      Map<String, dynamic> TokenFinal = jsonDecode(sToken!);
      String? token = TokenFinal['token'];

      print("Token RETORNADO: $token");

      final response = await http.get(
        Uri.parse(sUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        List<ProductoSingle> productItems = [];

        for (var item in jsonData) {
          productItems.add(ProductoSingle(
            calificacion: item["CALIFICACION"].toString(),
            img: item["IMAGEN"].toString(),
            nombre: item["NOMBRE"].toString(),
            vendedor: item["VENDEDOR"].toString(),
            id: item["idPRODUCTO"],
          ));
        }
        return productItems;
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al cargar productos');
    }
  }

  // Función para obtener todos los productos
  Future<List<ProductoSingle>> productosTotal() async {
    return await _fetchProductos('productos');
  }

  // Función para obtener productos favoritos
  Future<List<ProductoSingle>> favoritosTotal() async {
    return await _fetchProductos('favoritos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Zapatos y más zapatos"),
        actions: [
          IconButton(
            icon: Icon(
              _viewType == ViewType.list ? Icons.grid_on : Icons.view_list
            ),
            onPressed: () {
              setState(() {
                if (_viewType == ViewType.list) {
                  _crossAxisCount = 2;
                  _aspectRatio = 1.5;
                  _viewType = ViewType.grid;
                } else {
                  _crossAxisCount = 1;
                  _aspectRatio = 5;
                  _viewType = ViewType.list;
                }
              });
            },
          ),
          IconButton(
            icon: Icon(_showFavorites ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _showFavorites = !_showFavorites; // Alternar favoritos
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).canvasColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: FutureBuilder<List<ProductoSingle>>(
          future: _showFavorites ? favoritosTotal() : productosTotal(), // Cambiar entre productos y favoritos
          builder: (BuildContext context, AsyncSnapshot<List<ProductoSingle>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text("Cargando Información"),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error al cargar productos"),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return GridView.count(
                crossAxisCount: _crossAxisCount,
                childAspectRatio: _aspectRatio,
                children: snapshot.data!,
              );
            } else {
              return const Center(
                child: Text("No se encontraron productos"),
              );
            }
          },
        ),
      ),
    );
  }
}

enum ViewType { grid, list }
