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

