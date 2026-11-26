import 'package:atividade_receitas_professor/atividade_receitas/detalhes_receita.dart';
import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/widgets/imagem_receita.dart';
import 'package:flutter/material.dart';

class Favoritos extends StatelessWidget {
  final FavoritosController favoritos;

  const Favoritos({super.key, required this.favoritos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas Favoritas')),
      body: AnimatedBuilder(
        animation: favoritos,
        builder: (context, child) {
          if (favoritos.receitas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 70),
                  SizedBox(height: 16),
                  Text('Nenhuma receita favorita.'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favoritos.receitas.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final receita = favoritos.receitas[index];

              return Card(
                child: ListTile(
                  leading: ImagemReceita(receita: receita),
                  title: Text(receita.nome),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesReceita(
                          receita: receita,
                          favoritos: favoritos,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    tooltip: 'Remover dos favoritos',
                    onPressed: () => favoritos.remover(receita.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
