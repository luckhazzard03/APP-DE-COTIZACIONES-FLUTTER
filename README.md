# flutter_cotizaciones

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## ESTRUCTURA DEL PROYECTO 

cotizaciones_app/
├── android/
├── ios/
├── lib/
│   ├── models/
│   │   └── cotizacion.dart          # Modelo para la cotización
│   ├── screens/
│   │   ├── home_screen.dart         # Pantalla principal con el formulario
│   │   └── pdf_preview_screen.dart   # Pantalla para mostrar el PDF (opcional)
│   ├── services/
│   │   └── pdf_service.dart          # Servicio para generar el PDF
│   ├── widgets/
│   │   └── cotizacion_form.dart      # Widget del formulario
│   ├── main.dart                     # Punto de entrada de la aplicación
├── pubspec.yaml                      # Archivo de dependencias
└── assets/
    └── plantilla_cotizacion.pdf      # Tu plantilla PDF

#2. Implementar Compartición a través de WhatsApp y Email
Para compartir cotizaciones, puedes usar el paquete share_plus, que te permite compartir texto y archivos fácilmente. Asegúrate de agregarlo a tu pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  share_plus: ^6.1.0


Uso del Paquete share_plus
Importar el Paquete: En el archivo donde deseas implementar la funcionalidad de compartir:

import 'package:share_plus/share_plus.dart';


#Implementar la Función de Compartir: Agrega una función para compartir el archivo PDF que generaste:


void _compartirCotizacion(String filePath) {
  Share.shareFiles([filePath], text: 'Aquí tienes la cotización');
}


#Llamar a la Función de Compartir: Puedes llamar a _compartirCotizacion después de que hayas generado el PDF, justo antes de navegar a la vista previa:

final file = File("${output.path}/cotizacion.pdf");
await file.writeAsBytes(await pdf.save());

// Compartir el PDF
_compartirCotizacion(file.path);

// Navegar a la vista previa del PDF
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PdfPreviewScreen(pdfPath: file.path),
  ),
);


3. Pruebas y Ajustes
Prueba la funcionalidad en tu dispositivo para asegurarte de que todo funcione como esperas.
Ajusta cualquier diseño o funcionalidad adicional según sea necesario.
4. Generar APK o IPA
Si deseas distribuir tu aplicación:

Para Android: Puedes generar un archivo APK usando:

   flutter build apk --release


Para iOS: Usa Xcode para crear una versión de producción y seguir los pasos de distribución de aplicaciones.