
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

  static Future<int> insert(FavoritosClass favorito) async {
    Database database = await _openDB();
  
    return database.insert("favoritos", favorito.toMap());
  }

  static Future<int> delete(FavoritosClass favorito) async {
    Database database = await _openDB();
  
    return database.delete("favoritos", where: "id = ?", whereArgs: [favorito.id]);
  }


  static Future<List<FavoritosClass>> favoritos() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> favoritosMap = await database.query("favoritos");

    return List.generate(favoritosMap.length,
            (i) => FavoritosClass(
              id: favoritosMap[i]['idPRODUCTO'],
              nombre: favoritosMap[i]['NOMBRE'],
            ));
  }

}