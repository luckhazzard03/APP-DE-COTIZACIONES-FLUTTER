//cotizacion.dart
import 'itemCotizacion.dart';

class Cotizacion {
  String senores;
  String nit;
  String telefono;
  String direccion;
  int numeroCotizacion;
  String fecha;
  List<ItemCotizacion> items; // Cambiar a una lista de ítems

  Cotizacion({
    required this.senores,
    required this.nit,
    required this.telefono,
    required this.direccion,
    required this.numeroCotizacion,
    required this.fecha,
    required this.items, // Incluir la lista de ítems
  });

  double get valorTotal => items.fold(0, (total, item) => total + item.valorTotal);
}
