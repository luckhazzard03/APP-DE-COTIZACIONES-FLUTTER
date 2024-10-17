import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class PdfPreviewScreen extends StatelessWidget {
  final String pdfPath;

  const PdfPreviewScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Previa de Cotización'),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
