import 'package:atividade_receitas_professor/atividade_receitas/atividade_receitas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tela principal apresenta as opções do aplicativo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AtividadeReceitas());

    expect(find.text('Receitas'), findsOneWidget);
    expect(find.text('Ver receitas'), findsOneWidget);
    expect(find.text('Pesquisar receitas'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
  });

  testWidgets('abre a listagem e os detalhes de uma receita', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AtividadeReceitas());

    await tester.tap(find.text('Ver receitas'));
    await tester.pumpAndSettle();

    expect(find.text('Lista de Receitas'), findsOneWidget);
    expect(find.text('Bolo de cenoura'), findsOneWidget);

    await tester.tap(find.text('Bolo de cenoura'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da Receita'), findsOneWidget);
    expect(find.text('Ingredientes'), findsOneWidget);
    expect(find.text('Modo de preparo'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Lista de Receitas'), findsOneWidget);
  });

  testWidgets('abre a pesquisa e recusa consulta vazia', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AtividadeReceitas());

    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(
      find.text('Digite o nome da receita antes de pesquisar.'),
      findsOneWidget,
    );
  });

  testWidgets('pesquisa e abre o resultado encontrado', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AtividadeReceitas());

    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '  pão de queijo  ');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(find.text('Resultado para: pão de queijo'), findsOneWidget);

    await tester.tap(find.text('Pão de queijo'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da Receita'), findsOneWidget);
  });

  testWidgets('abre a tela de favoritos', (WidgetTester tester) async {
    await tester.pumpWidget(const AtividadeReceitas());

    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();

    expect(find.text('Receitas Favoritas'), findsOneWidget);
    expect(find.text('Nenhuma receita favorita.'), findsOneWidget);
  });
}
