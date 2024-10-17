import 'package:flutter/material.dart';
import '../widgets/cotizacion_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotización')),
      body: CotizacionForm(),
    );
  }
}
