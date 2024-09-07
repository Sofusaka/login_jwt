
import 'package:login_jwt/favoritos_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {

  static Future<Database> _openDB() async {

    return openDatabase(join(await getDatabasesPath(),'favoritos.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE favoritos (id INTEGER PRIMARY KEY, idProducto INT, nombre TEXT)",
        );
      }, version: 1);
  }


static Future<void> insertar(int id, String nombre) async {
  Database database = await _openDB();

  // Verificar si el producto ya está en favoritos
  var existing = await database.rawQuery("SELECT * FROM favoritos WHERE id = ?", [id]);
  
  if (existing.isNotEmpty) {
    print("El producto ya está en favoritos");
    return;
  }

  // Si no existe, proceder con la inserción
  var resultado = await database.rawInsert("INSERT INTO favoritos (id, nombre) VALUES (?, ?)", [id, nombre]);
  print("Resultado: $resultado");
}



static Future<void> eliminar(int id) async {
  Database database = await _openDB();
  var resultado = await database.rawDelete("DELETE FROM favoritos WHERE id = ?", [id]);
  print("Número de registros eliminados: $resultado");
}

static Future<void> eliminarTodos() async {
  Database database = await _openDB();
  var resultado = await database.rawDelete("DELETE FROM favoritos");
  print("Todos los registros eliminados: $resultado");
}



static Future<void> obtenerFavoritos() async {
  Database database = await _openDB();
  List<Map<String, dynamic>> favoritos = await database.rawQuery("SELECT * FROM favoritos");
  
  if (favoritos.isNotEmpty) {
    for (var favorito in favoritos) {
      print("ID: ${favorito['id']}, Nombre: ${favorito['nombre']}");
    }
  } else {
    print("No hay favoritos guardados.");
  }
}

}