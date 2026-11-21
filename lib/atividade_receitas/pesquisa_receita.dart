import 'package:atividade_receitas_professor/atividade_receitas/detalhes_receita.dart';
import 'package:flutter/material.dart';

class PesquisaReceita extends StatefulWidget {
  const PesquisaReceita({super.key});

  @override
  State<PesquisaReceita> createState() => _PesquisaReceitaState();
}

class _PesquisaReceitaState extends State<PesquisaReceita> {
  final receita = TextEditingController();
  String? mensagemErro;
  String? resultado;

  void pesquisar() {
    final texto = receita.text.trim();

    if (texto.isEmpty) {
      setState(() {
        mensagemErro = 'Digite o nome da receita antes de pesquisar.';
        resultado = null;
      });
      return;
    }

    setState(() {
      mensagemErro = null;
      resultado = texto;
    });
  }

  void limpar() {
    setState(() {
      receita.clear();
      mensagemErro = null;
      resultado = null;
    });
  }

  String nomeReceita(String texto) {
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }

  void abrirDetalhes() {
    final nome = nomeReceita(resultado!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalhesReceita(nome: nome)),
    );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: pesquisar,
                    child: const Text('Pesquisar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: limpar,
                    child: const Text('Limpar'),
                  ),
                ),
              ],
            ),
            if (resultado != null) ...[
              const SizedBox(height: 24),
              Text(
                'Resultado para: $resultado',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.restaurant)),
                  title: Text(nomeReceita(resultado!)),
                  subtitle: const Text('Toque para ver os detalhes'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: abrirDetalhes,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
