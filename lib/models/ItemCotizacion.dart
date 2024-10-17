class ItemCotizacion {
  String descripcion;
  int cantidad;
  double valorUnitario;

  ItemCotizacion({
    required this.descripcion,
    required this.cantidad,
    required this.valorUnitario,
  });

  double get valorTotal => cantidad * valorUnitario;
}
