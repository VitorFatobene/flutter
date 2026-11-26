import 'package:atividade_receitas_professor/atividade_receitas/detalhes_receita.dart';
import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:atividade_receitas_professor/servicos/receita_service.dart';
import 'package:atividade_receitas_professor/widgets/imagem_receita.dart';
import 'package:flutter/material.dart';

class PesquisaReceita extends StatefulWidget {
  final ReceitaApi service;
  final FavoritosController favoritos;

  const PesquisaReceita({
    super.key,
    required this.service,
    required this.favoritos,
  });

  @override
  State<PesquisaReceita> createState() => _PesquisaReceitaState();
}

class _PesquisaReceitaState extends State<PesquisaReceita> {
  final receita = TextEditingController();
  String? mensagemErro;
  String? termoPesquisado;
  List<Receita>? resultados;
  bool carregando = false;
  int versaoBusca = 0;

  Future<void> pesquisar() async {
    final texto = receita.text.trim();

    if (texto.isEmpty) {
      setState(() {
        mensagemErro = 'Digite o nome da receita antes de pesquisar.';
        resultados = null;
        termoPesquisado = null;
      });
      return;
    }

    if (carregando) {
      return;
    }

    final versaoAtual = ++versaoBusca;

    setState(() {
      carregando = true;
      mensagemErro = null;
      resultados = null;
      termoPesquisado = texto;
    });

    try {
      final receitasEncontradas = await widget.service.pesquisarReceitas(texto);

      if (!mounted || versaoAtual != versaoBusca) {
        return;
      }

      setState(() {
        resultados = receitasEncontradas;
      });
    } catch (erro) {
      if (!mounted || versaoAtual != versaoBusca) {
        return;
      }

      setState(() {
        mensagemErro = erro is ReceitaServiceException
            ? erro.mensagem
            : 'Não foi possível realizar a pesquisa.';
      });
    } finally {
      if (mounted && versaoAtual == versaoBusca) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void limpar() {
    versaoBusca++;
    setState(() {
      receita.clear();
      mensagemErro = null;
      termoPesquisado = null;
      resultados = null;
      carregando = false;
    });
  }

  void abrirDetalhes(Receita receitaSelecionada) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesReceita(
          receita: receitaSelecionada,
          favoritos: widget.favoritos,
        ),
      ),
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
              enabled: !carregando,
              decoration: const InputDecoration(
                labelText: 'Nome da receita',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => pesquisar(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: carregando ? null : pesquisar,
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
            if (carregando) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Text('Pesquisando...', textAlign: TextAlign.center),
            ],
            if (mensagemErro != null && !carregando) ...[
              const SizedBox(height: 24),
              Text(
                mensagemErro!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              if (termoPesquisado != null) ...[
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: pesquisar,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ],
            if (resultados != null && !carregando) ...[
              const SizedBox(height: 24),
              if (resultados!.isEmpty)
                const Text(
                  'Nenhuma receita encontrada.',
                  textAlign: TextAlign.center,
                )
              else ...[
                Text(
                  'Resultados para: $termoPesquisado',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                ...resultados!.map(
                  (resultado) => Card(
                    child: ListTile(
                      leading: ImagemReceita(receita: resultado),
                      title: Text(
                        resultado.nome,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: const Text('Toque para ver os detalhes'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => abrirDetalhes(resultado),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
