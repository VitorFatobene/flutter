import 'package:atividade_receitas_professor/atividade_receitas/tela_principal.dart';
import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/servicos/receita_service.dart';
import 'package:flutter/material.dart';

class AtividadeReceitas extends StatefulWidget {
  final ReceitaApi? service;
  final FavoritosController? favoritos;

  const AtividadeReceitas({super.key, this.service, this.favoritos});

  @override
  State<AtividadeReceitas> createState() => _AtividadeReceitasState();
}

class _AtividadeReceitasState extends State<AtividadeReceitas> {
  late final ReceitaApi service;
  late final FavoritosController favoritos;
  late final bool criouFavoritos;

  @override
  void initState() {
    super.initState();
    service = widget.service ?? ReceitaService();
    favoritos = widget.favoritos ?? FavoritosController();
    criouFavoritos = widget.favoritos == null;
  }

  @override
  void dispose() {
    if (criouFavoritos) {
      favoritos.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(service: service, favoritos: favoritos),
    );
  }
}
