
import 'package:flutter/material.dart';

class AddProjectScreen extends StatelessWidget {
  const AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Proyecto'),
      ),
      body: const Center(
        child: Text('Pantalla para agregar proyecto'),
      ),
    );
  }
}