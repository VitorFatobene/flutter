import 'package:atividade_receitas_professor/atividade_receitas/favoritos.dart';
import 'package:atividade_receitas_professor/atividade_receitas/lista_receitas.dart';
import 'package:atividade_receitas_professor/atividade_receitas/pesquisa_receita.dart';
import 'package:flutter/material.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  void abrirTela(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.restaurant_menu, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Receitas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => abrirTela(context, const ListaReceitas()),
              child: const Text('Ver receitas'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => abrirTela(context, const PesquisaReceita()),
              child: const Text('Pesquisar receitas'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => abrirTela(context, const Favoritos()),
              child: const Text('Favoritos'),
            ),
          ],
        ),
      ),
    );
  }
}
