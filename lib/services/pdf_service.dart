import 'dart:io';
import 'package:flutter/services.dart'; // Asegúrate de importar esto
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import '../models/cotizacion.dart';
import '../screens/pdf_preview_screen.dart';

class PdfService {
  static Future<void> generarPDF(
      BuildContext context, Cotizacion cotizacion) async {
    // Cargar la plantilla desde los assets
    final ByteData bytes =
        await rootBundle.load('assets/plantilla_cotizacion.pdf');
    final List<int> list = bytes.buffer.asUint8List();

    // Aquí puedes utilizar `list` si necesitas hacer modificaciones o simplemente generar el PDF
    final pdf = pw.Document();

    // Si deseas agregar la plantilla como fondo (esto depende de cómo quieras usarla)
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Señores: ${cotizacion.senores}',
                  style: pw.TextStyle(fontSize: 20)),
              pw.Text('NIT: ${cotizacion.nit}'),
              pw.Text('Teléfono: ${cotizacion.telefono}'),
              pw.Text('Dirección: ${cotizacion.direccion}'),
              pw.Text('Número de Cotización: ${cotizacion.numeroCotizacion}'),
              pw.Text('Fecha: ${cotizacion.fecha}'),
              pw.SizedBox(height: 20),
              pw.Text('Ítems:', style: pw.TextStyle(fontSize: 18)),
              for (var item in cotizacion.items)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(item.descripcion),
                    pw.Text('Cantidad: ${item.cantidad}'),
                    pw.Text(
                        'Valor Unitario: ${item.valorUnitario.toStringAsFixed(2)}'),
                    pw.Text('Total: ${item.valorTotal.toStringAsFixed(2)}'),
                  ],
                ),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Valor Total: ${cotizacion.valorTotal.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    // Guardar el PDF en un archivo temporal
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cotizacion.pdf");
    await file.writeAsBytes(await pdf.save());

    // Navegar a la vista previa del PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(pdfPath: file.path),
      ),
    );
  }
}
