class ItemCotizacion {
  String descripcion;
  int cantidad;
  double valorUnitario;

  ItemCotizacion({
    required this.descripcion,
    required this.cantidad,
    required this.valorUnitario,
  });

  // Método para convertir un objeto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'cantidad': cantidad,
      'valorUnitario': valorUnitario,
    };
  }

  // Método para crear un objeto a partir de un mapa
  factory ItemCotizacion.fromMap(Map<String, dynamic> map) {
    return ItemCotizacion(
      descripcion: map['descripcion'],
      cantidad: map['cantidad'],
      valorUnitario: map['valorUnitario'],
    );
  }

  // Calcular el valor total
  double get valorTotal => cantidad * valorUnitario;
}
