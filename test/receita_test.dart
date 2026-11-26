import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converte os campos da receita sem presumir tipos incorretos', () {
    final receita = Receita.fromJson({
      'id': 1,
      'name': null,
      'ingredients': ['Farinha', 10],
      'instructions': ['Misture os ingredientes'],
      'image': '',
      'prepTimeMinutes': 12.8,
      'cookTimeMinutes': null,
      'servings': '4',
      'rating': 4,
      'mealType': ['Breakfast', 2],
      'difficulty': 'Easy',
      'cuisine': 'Italian',
      'caloriesPerServing': 320,
      'tags': ['Pizza', 2],
      'reviewCount': 12,
    });

    expect(receita.id, 1);
    expect(receita.nome, 'Receita sem nome');
    expect(receita.ingredientes, ['Farinha']);
    expect(receita.instrucoes, ['Misture os ingredientes']);
    expect(receita.imagem, isNull);
    expect(receita.tempoPreparo, isNull);
    expect(receita.tempoCozimento, isNull);
    expect(receita.porcoes, isNull);
    expect(receita.avaliacao, 4.0);
    expect(receita.tiposRefeicao, ['Breakfast']);
    expect(receita.dificuldade, 'Easy');
    expect(receita.culinaria, 'Italian');
    expect(receita.caloriasPorPorcao, 320);
    expect(receita.tags, ['Pizza']);
    expect(receita.quantidadeAvaliacoes, 12);
    expect(receita.tempoTotal, isNull);
  });

  test('rejeita identificador fracionário', () {
    expect(
      () => Receita.fromJson({'id': 1.5}),
      throwsA(isA<FormatException>()),
    );
  });
}
