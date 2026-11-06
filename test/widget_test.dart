import 'package:atividade_receitas_professor/atividade_receitas/atividade_receitas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe campo e botão de pesquisa', (WidgetTester tester) async {
    await tester.pumpWidget(const AtividadeReceitas());

    expect(find.text('Nome da receita'), findsOneWidget);
    expect(find.text('Pesquisar'), findsOneWidget);
  });

  testWidgets('recusa pesquisa vazia e somente com espaços', (
    WidgetTester tester,
  ) async {
    for (final pesquisa in ['', '   ']) {
      await tester.pumpWidget(const AtividadeReceitas());
      await tester.enterText(find.byType(TextField), pesquisa);
      await tester.tap(find.text('Pesquisar'));
      await tester.pump();

      expect(
        find.text('Digite o nome da receita antes de pesquisar.'),
        findsOneWidget,
      );
      expect(find.textContaining('Pesquisa realizada:'), findsNothing);
    }
  });

  testWidgets('mostra o termo e permite nova pesquisa', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AtividadeReceitas());

    await tester.enterText(find.byType(TextField), '  bolo de cenoura  ');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(find.text('Pesquisa realizada: bolo de cenoura'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'pão de queijo');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(find.text('Pesquisa realizada: pão de queijo'), findsOneWidget);
  });
}
