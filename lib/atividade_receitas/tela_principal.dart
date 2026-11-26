import 'package:atividade_receitas_professor/atividade_receitas/favoritos.dart';
import 'package:atividade_receitas_professor/atividade_receitas/lista_receitas.dart';
import 'package:atividade_receitas_professor/atividade_receitas/pesquisa_receita.dart';
import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:atividade_receitas_professor/servicos/receita_service.dart';
import 'package:flutter/material.dart';

class TelaPrincipal extends StatefulWidget {
  final ReceitaApi service;
  final FavoritosController favoritos;

  const TelaPrincipal({
    super.key,
    required this.service,
    required this.favoritos,
  });

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late Future<List<Receita>> carregamento;

  @override
  void initState() {
    super.initState();
    carregamento = widget.service.listarReceitas();
  }

  void tentarNovamente() {
    setState(() {
      carregamento = widget.service.listarReceitas();
    });
  }

  void abrirTela(Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
  }

  String mensagemErro(Object? erro) {
    if (erro is ReceitaServiceException) {
      return erro.mensagem;
    }
    return 'Não foi possível carregar as receitas.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: FutureBuilder<List<Receita>>(
        future: carregamento,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.restaurant_menu, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Receitas Vascainas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                if (snapshot.connectionState == ConnectionState.waiting) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 12),
                  const Text(
                    'Carregando receitas...',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ] else if (snapshot.hasError) ...[
                  Text(
                    mensagemErro(snapshot.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: tentarNovamente,
                    child: const Text('Tentar novamente'),
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton(
                  onPressed: snapshot.hasData
                      ? () => abrirTela(
                          ListaReceitas(
                            receitas: snapshot.data ?? [],
                            favoritos: widget.favoritos,
                          ),
                        )
                      : null,
                  child: const Text('Ver receitas'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => abrirTela(
                    PesquisaReceita(
                      service: widget.service,
                      favoritos: widget.favoritos,
                    ),
                  ),
                  child: const Text('Pesquisar receitas'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () =>
                      abrirTela(Favoritos(favoritos: widget.favoritos)),
                  child: const Text('Favoritos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
