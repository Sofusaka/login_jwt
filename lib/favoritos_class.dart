class FavoritosClass{

  int id;
  String nombre;


  FavoritosClass({
    required this.id,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

}