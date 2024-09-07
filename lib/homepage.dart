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


  Future<Widget> productos_total() async {
      
        String apiUrl ='192.168.0.16';
        String sUrl = "http://$apiUrl:3000/productos";

        String? sToken = await _loginService.getUserData();
        Map<String, dynamic> TokenFinal = jsonDecode(sToken!);
        String? token = TokenFinal['token'];


        print("Token RETORNADO: $token");
      
        final oRespuesta = await http.get(
          Uri.parse(sUrl),
          headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization':'Bearer $token'},
        );
        print(oRespuesta.body);



         List<dynamic> oJsonDatos = jsonDecode(utf8.decode(oRespuesta.bodyBytes));
     
        List<Widget> awItems = [];
      
        for (var i = 0; i < oJsonDatos.length; i++) {
          var item = oJsonDatos[i];
      
      
          awItems.add(ProductoSingle(
              calificacion: item["CALIFICACION"].toString(),
              img: item["IMAGEN"].toString(),
              nombre: item["NOMBRE"].toString(),
              vendedor: item["VENDEDOR"].toString(),
              id: item["idPRODUCTO"],
          ));
               
        }

      return GridView.count(
                  crossAxisCount: _crossAxisCount,
                  childAspectRatio: _aspectRatio,
                  children: awItems
                );

      }



  Future<Widget> favoritos_total() async {
  String apiUrl = '192.168.0.16';
  String sUrl = "http://$apiUrl:3000/favoritos";

  String? sToken = await _loginService.getUserData();
  Map<String, dynamic> TokenFinal = jsonDecode(sToken!);
  String? token = TokenFinal['token'];

  print("Token RETORNADO: $token");

  final oRespuesta = await http.get(
    Uri.parse(sUrl),
    headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
  );
  print(oRespuesta.body);

  List<dynamic> oJsonDatos = jsonDecode(utf8.decode(oRespuesta.bodyBytes));
  List<Widget> awItems = [];

  for (var i = 0; i < oJsonDatos.length; i++) {
    var item = oJsonDatos[i];

    awItems.add(ProductoSingle(
      id: item["idPRODUCTO"],
      calificacion: item["CALIFICACION"].toString(),
      img: item["IMAGEN"].toString(),
      nombre: item["NOMBRE"].toString(),
      vendedor: item["VENDEDOR"].toString(),
    ));
  }

  return GridView.count(
    crossAxisCount: _crossAxisCount,
    childAspectRatio: _aspectRatio,
    children: awItems,
  );
}


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

                //operación de inversión de valor. Cambia el valor de _showFavorites de true a false y viceversa.
                _showFavorites = !_showFavorites; 
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
        child: FutureBuilder<Widget>(
          future: _showFavorites ? favoritos_total() : productos_total(), // Cambiar entre productos y favoritos
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data ?? Container();
            }
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text("Cargando Información"),
              ],
            );
          },
        ),
      ),
    );
  }


   

}

enum ViewType { grid, list }