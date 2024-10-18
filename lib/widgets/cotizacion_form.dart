import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cotizacion.dart';
import '../models/itemCotizacion.dart';
import '../services/pdf_service.dart';

class CotizacionForm extends StatefulWidget {
  @override
  _CotizacionFormState createState() => _CotizacionFormState();
}

class _CotizacionFormState extends State<CotizacionForm> {
  final _formKey = GlobalKey<FormState>();
  String? senores, nit, telefono, direccion, fecha;
  int? numeroCotizacion;
  List<ItemCotizacion> items = [];

  // Controladores para los campos de ítem
  TextEditingController descripcionController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController valorUnitarioController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    fechaController.text = fecha ?? '';
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        fecha = DateFormat('yyyy-MM-dd').format(picked);
        fechaController.text = fecha!; // Actualiza el controlador
      });
    }
  }

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
        items[editingIndex!] = ItemCotizacion(
          descripcion: descripcion,
          cantidad: cantidad,
          valorUnitario: valorUnitario,
        );
        editingIndex = null;
      }
      _limpiarCampos();
    });
  }

  void _editarItem(int index) {
    final item = items[index];
    descripcionController.text = item.descripcion;
    cantidadController.text = item.cantidad.toString();
    valorUnitarioController.text = item.valorUnitario.toString();

    setState(() {
      editingIndex = index;
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
        items: items,
      );
      PdfService.generarPDFSimple(cotizacion).then((pdfBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF generado con éxito')),
        );
      }).catchError((error) {
        print('Error al generar PDF: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar PDF')),
        );
      });
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
              _buildTextFormField(
                'Número de Cotización',
                (value) => numeroCotizacion = int.tryParse(value!),
                keyboardType: TextInputType.number,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: fechaController,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      hintText: 'Selecciona una fecha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              _buildItemFields(),
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
