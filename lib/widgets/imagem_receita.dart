import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:flutter/material.dart';

class ImagemReceita extends StatelessWidget {
  final Receita receita;
  final double largura;
  final double altura;

  const ImagemReceita({
    super.key,
    required this.receita,
    this.largura = 56,
    this.altura = 56,
  });

  Widget imagemAlternativa() {
    return Container(
      key: const Key('imagem-alternativa'),
      width: largura,
      height: altura,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.restaurant),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (receita.imagem == null) {
      return imagemAlternativa();
    }

    return Image.network(
      receita.imagem!,
      width: largura,
      height: altura,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => imagemAlternativa(),
    );
  }
}
