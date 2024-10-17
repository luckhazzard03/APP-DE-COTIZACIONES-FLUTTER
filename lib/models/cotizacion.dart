import 'itemCotizacion.dart';

class Cotizacion {
  String senores;
  String nit;
  String telefono;
  String direccion;
  int numeroCotizacion;
  String fecha;
  List<ItemCotizacion> items;

  Cotizacion({
    required this.senores,
    required this.nit,
    required this.telefono,
    required this.direccion,
    required this.numeroCotizacion,
    required this.fecha,
    required this.items,
  });

  // Método para convertir la cotización a un mapa (para guardar en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'senores': senores,
      'nit': nit,
      'telefono': telefono,
      'direccion': direccion,
      'numeroCotizacion': numeroCotizacion,
      'fecha': fecha,
      'items': items.map((item) => item.toMap()).toList(), // Convertir ítems a mapa
    };
  }

  // Método para crear una cotización a partir de un mapa (de la base de datos)
  static Cotizacion fromMap(Map<String, dynamic> map) {
    return Cotizacion(
      senores: map['senores'],
      nit: map['nit'],
      telefono: map['telefono'],
      direccion: map['direccion'],
      numeroCotizacion: map['numeroCotizacion'],
      fecha: map['fecha'],
      items: List<ItemCotizacion>.from(
        (map['items'] as List)
            .map((itemMap) => ItemCotizacion.fromMap(itemMap)),
      ),
    );
  }

  double get valorTotal =>
      items.fold(0, (total, item) => total + item.valorTotal);
}
