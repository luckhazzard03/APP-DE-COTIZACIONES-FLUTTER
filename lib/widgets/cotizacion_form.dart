import 'package:flutter/material.dart';
import '../models/cotizacion.dart';
import '../models/itemCotizacion.dart'; // Importar el modelo
import '../services/pdf_service.dart';

class CotizacionForm extends StatefulWidget {
  @override
  _CotizacionFormState createState() => _CotizacionFormState();
}

class _CotizacionFormState extends State<CotizacionForm> {
  final _formKey = GlobalKey<FormState>();
  String? senores, nit, telefono, direccion, fecha;
  int? numeroCotizacion;
  List<ItemCotizacion> items = []; // Lista para almacenar ítems

  // Controladores para los campos de ítem
  TextEditingController descripcionController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController valorUnitarioController = TextEditingController();
  int? editingIndex; // Para saber qué ítem se está editando

  bool _validarCampos() {
    final descripcion = descripcionController.text;
    final cantidad = int.tryParse(cantidadController.text);
    final valorUnitario = double.tryParse(valorUnitarioController.text);

    if (descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La descripción es obligatoria.'),
      ));
      return false;
    }
    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La cantidad debe ser un número positivo.'),
      ));
      return false;
    }
    if (valorUnitario == null || valorUnitario <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('El valor unitario debe ser un número positivo.'),
      ));
      return false;
    }

    return true;
  }

  void _agregarItem() {
    if (!_validarCampos()) return;

    final descripcion = descripcionController.text;
    final cantidad = int.parse(cantidadController.text);
    final valorUnitario = double.parse(valorUnitarioController.text);

    setState(() {
      if (editingIndex == null) {
        items.add(ItemCotizacion(
          descripcion: descripcion,
          cantidad: cantidad,
          valorUnitario: valorUnitario,
        ));
      } else {
        // Actualizar ítem existente
        items[editingIndex!] = ItemCotizacion(
          descripcion: descripcion,
          cantidad: cantidad,
          valorUnitario: valorUnitario,
        );
        editingIndex = null; // Restablecer el índice de edición
      }
      // Limpiar los campos después de agregar o actualizar
      _limpiarCampos();
    });
  }

  void _editarItem(int index) {
    final item = items[index];
    descripcionController.text = item.descripcion;
    cantidadController.text = item.cantidad.toString();
    valorUnitarioController.text = item.valorUnitario.toString();

    setState(() {
      editingIndex = index; // Establecer el índice de edición
    });
  }

  void _eliminarItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _limpiarCampos() {
    descripcionController.clear();
    cantidadController.clear();
    valorUnitarioController.clear();
  }

  void _generarPDF() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final cotizacion = Cotizacion(
        senores: senores!,
        nit: nit!,
        telefono: telefono!,
        direccion: direccion!,
        numeroCotizacion: numeroCotizacion!,
        fecha: fecha!,
        items: items, // Pasar la lista de ítems
      );
      PdfService.generarPDF(context, cotizacion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextFormField('Señores', (value) => senores = value),
              _buildTextFormField('NIT o CC', (value) => nit = value),
              _buildTextFormField('Teléfono', (value) => telefono = value),
              _buildTextFormField('Dirección', (value) => direccion = value),
              _buildTextFormField('Número de Cotización',
                  (value) => numeroCotizacion = int.tryParse(value!),
                  keyboardType: TextInputType.number),
              _buildTextFormField('Fecha', (value) => fecha = value),

              // Campos para agregar ítems
              _buildItemFields(),

              // Botón para agregar o actualizar ítem
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _agregarItem,
                child: Text(
                  editingIndex == null ? 'Agregar Ítem' : 'Actualizar Ítem',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 129, 240, 255),
                  foregroundColor: const Color.fromARGB(255, 38, 24, 45),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),

              // Mostrar la lista de ítems
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.descripcion),
                    subtitle: Text(
                      'Cantidad: ${item.cantidad}, Valor Unitario: ${item.valorUnitario}, Total: ${item.cantidad * item.valorUnitario}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editarItem(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _generarPDF,
                child: Text('Generar Cotización'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 37, 27, 44),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String?)? onSaved,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildItemFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: descripcionController,
            decoration: InputDecoration(
              labelText: 'Descripción del Ítem',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: cantidadController,
            decoration: InputDecoration(
              labelText: 'Cantidad',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: valorUnitarioController,
            decoration: InputDecoration(
              labelText: 'Valor Unitario',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
