import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:atividade_receitas_professor/widgets/imagem_receita.dart';
import 'package:flutter/material.dart';

class DetalhesReceita extends StatelessWidget {
  final Receita receita;
  final FavoritosController favoritos;

  const DetalhesReceita({
    super.key,
    required this.receita,
    required this.favoritos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Receita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ImagemReceita(receita: receita, largura: 260, altura: 220),
            ),
            const SizedBox(height: 16),
            Text(
              receita.nome,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: favoritos,
              builder: (context, child) {
                final estaNosFavoritos = favoritos.contem(receita.id);

                return FilledButton.icon(
                  onPressed: () => favoritos.alternar(receita),
                  icon: Icon(
                    estaNosFavoritos ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    estaNosFavoritos
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (receita.tempoPreparo != null)
              Text('Preparo: ${receita.tempoPreparo} minutos'),
            if (receita.tempoCozimento != null)
              Text('Cozimento: ${receita.tempoCozimento} minutos'),
            if (receita.tempoTotal != null)
              Text('${receita.tempoTotal} minutos no total'),
            if (receita.porcoes != null) Text('${receita.porcoes} porções'),
            if (receita.avaliacao != null)
              Text('Avaliação: ${receita.avaliacao}'),
            if (receita.dificuldade != null)
              Text('Dificuldade: ${receita.dificuldade}'),
            if (receita.culinaria != null)
              Text('Culinária: ${receita.culinaria}'),
            if (receita.caloriasPorPorcao != null)
              Text('${receita.caloriasPorPorcao} calorias por porção'),
            if (receita.quantidadeAvaliacoes != null)
              Text('${receita.quantidadeAvaliacoes} avaliações'),
            if (receita.tiposRefeicao.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: receita.tiposRefeicao
                    .map((tipo) => Chip(label: Text(tipo)))
                    .toList(),
              ),
            ],
            if (receita.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: receita.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Ingredientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (receita.ingredientes.isEmpty)
              const Text('Ingredientes não informados.')
            else
              ...receita.ingredientes.map((item) => Text('• $item')),
            const SizedBox(height: 24),
            const Text(
              'Modo de preparo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (receita.instrucoes.isEmpty)
              const Text('Instruções não informadas.')
            else
              ...receita.instrucoes.indexed.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('${item.$1 + 1}. ${item.$2}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
