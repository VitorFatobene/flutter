import 'package:atividade_receitas_professor/atividade_receitas/pesquisa_receita.dart';
import 'package:flutter/material.dart';

class AtividadeReceitas extends StatelessWidget {
  const AtividadeReceitas({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PesquisaReceita(),
    );
  }
}
