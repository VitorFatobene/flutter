import 'package:atividade_receitas_professor/controles/favoritos_controller.dart';
import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const receita = Receita(
    id: 1,
    nome: 'Pizza',
    ingredientes: [],
    instrucoes: [],
    imagem: null,
    tempoPreparo: null,
    tempoCozimento: null,
    porcoes: null,
    avaliacao: null,
    tiposRefeicao: [],
  );

  test('adiciona e remove favorito sem duplicar pelo id', () {
    final favoritos = FavoritosController();

    favoritos.adicionar(receita);
    favoritos.adicionar(receita);

    expect(favoritos.receitas, hasLength(1));
    expect(favoritos.contem(1), isTrue);

    favoritos.remover(1);

    expect(favoritos.receitas, isEmpty);
    expect(favoritos.contem(1), isFalse);
  });
}
