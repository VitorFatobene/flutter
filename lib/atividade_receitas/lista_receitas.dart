import 'package:atividade_receitas_professor/atividade_receitas/detalhes_receita.dart';
import 'package:flutter/material.dart';

class ListaReceitas extends StatelessWidget {
  const ListaReceitas({super.key});

  void abrirDetalhes(BuildContext context, String nome) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalhesReceita(nome: nome)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receitas = ['Bolo de cenoura', 'Pão de queijo', 'Lasanha'];

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Receitas')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: receitas.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final receita = receitas[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.restaurant)),
              title: Text(receita),
              subtitle: const Text('Toque para ver os detalhes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => abrirDetalhes(context, receita),
            ),
          );
        },
      ),
    );
  }
}
