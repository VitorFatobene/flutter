import 'package:flutter/material.dart';

class PesquisaReceita extends StatefulWidget {
  const PesquisaReceita({super.key});

  @override
  State<PesquisaReceita> createState() => _PesquisaReceitaState();
}

class _PesquisaReceitaState extends State<PesquisaReceita> {
  final receita = TextEditingController();
  String? mensagemErro;

  void pesquisar() {
    final texto = receita.text.trim();

    if (texto.isEmpty) {
      setState(() {
        mensagemErro = 'Digite o nome da receita antes de pesquisar.';
      });
      return;
    }

    setState(() {
      mensagemErro = null;
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Pesquisa realizada: $texto')));

    receita.clear();
  }

  @override
  void dispose() {
    receita.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa de Receitas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: receita,
              decoration: InputDecoration(
                labelText: 'Nome da receita',
                errorText: mensagemErro,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: pesquisar, child: const Text('Pesquisar')),
          ],
        ),
      ),
    );
  }
}
