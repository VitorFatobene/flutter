import 'package:atividade_receitas_professor/atividade_receitas/detalhes_receita.dart';
import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:atividade_receitas_professor/widgets/imagem_receita.dart';
import 'package:flutter/material.dart';

class ListaReceitas extends StatelessWidget {
  final List<Receita> receitas;
  final FavoritosController favoritos;

  const ListaReceitas({
    super.key,
    required this.receitas,
    required this.favoritos,
  });

  void abrirDetalhes(BuildContext context, Receita receita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetalhesReceita(receita: receita, favoritos: favoritos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Receitas')),
      body: receitas.isEmpty
          ? const Center(child: Text('Nenhuma receita disponível.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: receitas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final receita = receitas[index];

                return Card(
                  child: ListTile(
                    leading: ImagemReceita(receita: receita),
                    title: Text(
                      receita.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
