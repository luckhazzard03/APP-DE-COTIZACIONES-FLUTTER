import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // Asegúrate de importar esto
import 'package:open_file/open_file.dart'; // Para abrir el archivo PDF
import '../models/cotizacion.dart';
import '../models/itemCotizacion.dart';

class PdfService {
  static Future<Uint8List> generarPDFSimple(Cotizacion cotizacion) async {
    final pdf = pw.Document();

    // Cargar la fuente
    final font = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    final boldFont = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldFont);

    // Cargar la plantilla desde los assets
    final ByteData bytes =
        await rootBundle.load('assets/plantilla_cotizacion.pdf');
    final Uint8List plantillaBytes = bytes.buffer.asUint8List();
    print(
        'Plantilla cargada: ${plantillaBytes.length} bytes'); // Agrega esta línea para verificar la carga

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Fondo: plantilla
              pw.Image(pw.MemoryImage(plantillaBytes), fit: pw.BoxFit.cover),
              // Contenido
              pw.Padding(
                padding: const pw.EdgeInsets.all(
                    30), // Ajusta el padding según necesites
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Cotización',
                        style: pw.TextStyle(font: ttfBold, fontSize: 20)),
                    pw.SizedBox(height: 10),
                    pw.Text('Señores: ${cotizacion.senores}',
                        style: pw.TextStyle(font: ttf)),
                    pw.Text('NIT: ${cotizacion.nit}',
                        style: pw.TextStyle(font: ttf)),
                    pw.Text('Teléfono: ${cotizacion.telefono}',
                        style: pw.TextStyle(font: ttf)),
                    pw.Text('Dirección: ${cotizacion.direccion}',
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        'Número de Cotización: ${cotizacion.numeroCotizacion}',
                        style: pw.TextStyle(font: ttf)),
                    pw.Text('Fecha: ${cotizacion.fecha}',
                        style: pw.TextStyle(font: ttf)),
                    pw.SizedBox(height: 20),
                    pw.Text('Ítems:', style: pw.TextStyle(font: ttfBold)),
                    _crearTablaItemsSimple(cotizacion.items, ttf, ttfBold),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        'Valor Total: ${cotizacion.valorTotal.toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttfBold)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    print('Tamaño del PDF: ${pdfBytes.length}'); // Imprime el tamaño del PDF

    return pdfBytes; // Devuelve los bytes del PDF
  }

  static pw.Widget _crearTablaItemsSimple(
      List<ItemCotizacion> items, pw.Font font, pw.Font boldFont) {
    print('Número de ítems: ${items.length}'); // Verifica la cantidad de ítems
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Text('Descripción', style: pw.TextStyle(font: boldFont)),
            pw.Text('Cantidad', style: pw.TextStyle(font: boldFont)),
            pw.Text('Valor Unitario', style: pw.TextStyle(font: boldFont)),
            pw.Text('Total', style: pw.TextStyle(font: boldFont)),
          ],
        ),
        ...items
            .map((item) => pw.TableRow(
                  children: [
                    pw.Text(item.descripcion, style: pw.TextStyle(font: font)),
                    pw.Text(item.cantidad.toString(),
                        style: pw.TextStyle(font: font)),
                    pw.Text(item.valorUnitario.toStringAsFixed(2),
                        style: pw.TextStyle(font: font)),
                    pw.Text(item.valorTotal.toStringAsFixed(2),
                        style: pw.TextStyle(font: font)),
                  ],
                ))
            .toList(),
      ],
    );
  }

  static Future<void> mostrarPDF(Uint8List pdfBytes) async {
    final directory =
        await getTemporaryDirectory(); // Obtiene el directorio temporal
    final filePath =
        '${directory.path}/cotizacion.pdf'; // Define la ruta del archivo

    final file = File(filePath);
    await file.writeAsBytes(pdfBytes); // Guarda el PDF
    OpenFile.open(filePath); // Abre el PDF
  }

  // Si deseas mantener la funcionalidad de generar PDF con plantilla, puedes agregar este método:
  static Future<Uint8List> generarPDFConPlantilla(Cotizacion cotizacion) async {
    final pdf = pw.Document();

    // Cargar la plantilla desde los assets
    final ByteData bytes =
        await rootBundle.load('assets/plantilla_cotizacion.pdf');
    final Uint8List plantillaBytes = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(plantillaBytes), fit: pw.BoxFit.cover),
              pw.Padding(
                padding: pw.EdgeInsets.all(30),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Aquí puedes agregar el contenido similar al PDF simple
                    // pero ajustado para que se ajuste a tu plantilla
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
