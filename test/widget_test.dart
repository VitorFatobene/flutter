import 'dart:async';

import 'package:atividade_receitas_professor/atividade_receitas/atividade_receitas.dart';
import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:atividade_receitas_professor/servicos/receita_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const pizza = Receita(
  id: 1,
  nome: 'Pizza',
  ingredientes: ['Massa', 'Queijo'],
  instrucoes: ['Montar a pizza', 'Assar'],
  imagem: null,
  tempoPreparo: 20,
  tempoCozimento: 15,
  porcoes: 4,
  avaliacao: 4.5,
  tiposRefeicao: ['Dinner'],
  dificuldade: 'Easy',
  culinaria: 'Italian',
  caloriasPorPorcao: 320,
  tags: ['Pizza', 'Dinner'],
  quantidadeAvaliacoes: 12,
);

class ReceitaApiFake implements ReceitaApi {
  List<Receita> receitas = [pizza];
  List<Receita> resultados = [pizza];
  Object? erroListagem;
  Object? erroPesquisa;
  String? termoRecebido;
  Completer<List<Receita>>? carregamento;
  Completer<List<Receita>>? pesquisa;
  int quantidadePesquisas = 0;

  @override
  Future<List<Receita>> listarReceitas() async {
    if (carregamento != null) {
      return carregamento!.future;
    }

    if (erroListagem != null) {
      throw erroListagem!;
    }

    return receitas;
  }

  @override
  Future<List<Receita>> pesquisarReceitas(String termo) async {
    quantidadePesquisas++;
    termoRecebido = termo;

    if (pesquisa != null) {
      return pesquisa!.future;
    }

    if (erroPesquisa != null) {
      throw erroPesquisa!;
    }

    return resultados;
  }
}

void main() {
  testWidgets('carrega receitas ao abrir e depois libera os acessos', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    final carregamento = Completer<List<Receita>>();
    api.carregamento = carregamento;

    await tester.pumpWidget(AtividadeReceitas(service: api));

    expect(find.text('Receitas Vascainas'), findsOneWidget);
    expect(find.text('Carregando receitas...'), findsOneWidget);
    expect(find.text('Pesquisar receitas'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Ver receitas'),
          )
          .onPressed,
      isNull,
    );

    carregamento.complete([pizza]);
    await tester.pumpAndSettle();

    expect(find.text('Ver receitas'), findsOneWidget);
    expect(find.text('Pesquisar receitas'), findsOneWidget);
  });

  testWidgets('mostra listagem e detalhes recebidos da API', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ver receitas'));
    await tester.pumpAndSettle();

    expect(find.text('Pizza'), findsOneWidget);
    expect(find.byKey(const Key('imagem-alternativa')), findsOneWidget);

    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Massa'), findsOneWidget);
    expect(find.textContaining('Montar a pizza'), findsOneWidget);
    expect(find.text('35 minutos no total'), findsOneWidget);
    expect(find.text('4 porções'), findsOneWidget);
    expect(find.text('Avaliação: 4.5'), findsOneWidget);
    expect(find.text('Dificuldade: Easy'), findsOneWidget);
    expect(find.text('Culinária: Italian'), findsOneWidget);
    expect(find.text('320 calorias por porção'), findsOneWidget);
    expect(find.text('12 avaliações'), findsOneWidget);
    expect(find.text('Pizza'), findsWidgets);
    expect(find.text('Dinner'), findsWidgets);
  });

  testWidgets('pesquisa termo remoto tratando espaços externos', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  pizza  ');
    await tester.tap(find.text('Pesquisar'));
    await tester.pumpAndSettle();

    expect(api.termoRecebido, 'pizza');
    expect(find.text('Pizza'), findsOneWidget);
  });

  testWidgets('distingue pesquisa vazia de pesquisa sem resultados', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    api.resultados = [];
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(
      find.text('Digite o nome da receita antes de pesquisar.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'inexistente');
    await tester.tap(find.text('Pesquisar'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhuma receita encontrada.'), findsOneWidget);
  });

  testWidgets('mostra erro de listagem e permite tentar novamente', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    api.erroListagem = const ReceitaServiceException('Falha de rede.');
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();

    expect(find.text('Falha de rede.'), findsOneWidget);
    expect(find.text('Pesquisar receitas'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Ver receitas'),
          )
          .onPressed,
      isNull,
    );

    api.erroListagem = null;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();

    expect(find.text('Ver receitas'), findsOneWidget);
  });

  testWidgets('adiciona e remove favorito durante a sessão', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ver receitas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar aos favoritos'));
    await tester.pump();

    expect(find.text('Remover dos favoritos'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();

    expect(find.text('Pizza'), findsOneWidget);

    await tester.tap(find.byTooltip('Remover dos favoritos'));
    await tester.pump();

    expect(find.text('Nenhuma receita favorita.'), findsOneWidget);
  });

  testWidgets('permite repetir pesquisa após erro', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    api.erroPesquisa = const ReceitaServiceException('Falha na pesquisa.');
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'pizza');
    await tester.tap(find.text('Pesquisar'));
    await tester.pumpAndSettle();

    expect(find.text('Falha na pesquisa.'), findsOneWidget);

    api.erroPesquisa = null;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();

    expect(api.quantidadePesquisas, 2);
    expect(find.text('Pizza'), findsOneWidget);
  });

  testWidgets('limpa durante pesquisa e ignora resposta anterior', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    final pesquisa = Completer<List<Receita>>();
    api.pesquisa = pesquisa;
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'pizza');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    await tester.tap(find.text('Limpar'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('pizza'), findsNothing);

    pesquisa.complete([pizza]);
    await tester.pumpAndSettle();

    expect(find.text('Pizza'), findsNothing);
  });

  testWidgets('preserva pesquisa ao voltar dos detalhes', (
    WidgetTester tester,
  ) async {
    final api = ReceitaApiFake();
    await tester.pumpWidget(AtividadeReceitas(service: api));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesquisar receitas'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'pizza');
    await tester.tap(find.text('Pesquisar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('pizza'), findsOneWidget);
    expect(find.text('Pizza'), findsOneWidget);
  });
}
