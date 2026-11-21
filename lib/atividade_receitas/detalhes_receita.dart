import 'package:flutter/material.dart';

class DetalhesReceita extends StatelessWidget {
  final String nome;

  const DetalhesReceita({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Receita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.restaurant, size: 100)),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ingredientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Ingrediente 1'),
            const Text('• Ingrediente 2'),
            const Text('• Ingrediente 3'),
            const SizedBox(height: 24),
            const Text(
              'Modo de preparo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Primeiro passo da receita.'),
            const Text('2. Segundo passo da receita.'),
            const Text('3. Finalize e sirva.'),
          ],
        ),
      ),
    );
  }
}
