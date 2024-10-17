import 'dart:io';
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
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Señores: ${cotizacion.senores}'),
              // Otros campos...
              pw.Text('Ítems:'),
              for (var item in cotizacion.items)
                pw.Text(
                    '${item.descripcion}: Cantidad ${item.cantidad}, Valor Unitario ${item.valorUnitario}, Total ${item.valorTotal}'),
              pw.Text('Valor Total: ${cotizacion.valorTotal}'),
            ],
          );
        },
      ),
    );

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
