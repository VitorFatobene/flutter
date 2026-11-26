import 'dart:async';
import 'dart:convert';

import 'package:atividade_receitas_professor/servicos/receita_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('lista receitas recebidas da API', () async {
    final cliente = MockClient((request) async {
      expect(request.url.path, '/recipes');
      expect(request.url.queryParameters['limit'], '20');

      return http.Response(
        jsonEncode({
          'recipes': [
            {
              'id': 1,
              'name': 'Classic Margherita Pizza',
              'ingredients': ['Pizza dough'],
              'instructions': ['Bake'],
              'image': 'https://exemplo.com/pizza.png',
              'prepTimeMinutes': 20,
              'cookTimeMinutes': 15,
              'servings': 4,
              'rating': 4.5,
              'mealType': ['Dinner'],
            },
          ],
        }),
        200,
      );
    });

    final service = ReceitaService(cliente: cliente);
    final receitas = await service.listarReceitas();

    expect(receitas, hasLength(1));
    expect(receitas.first.id, 1);
    expect(receitas.first.nome, 'Classic Margherita Pizza');
  });

  test('pesquisa receitas usando o termo informado', () async {
    final cliente = MockClient((request) async {
      expect(request.url.path, '/recipes/search');
      expect(request.url.queryParameters['q'], 'pizza');
      return http.Response(jsonEncode({'recipes': []}), 200);
    });

    final service = ReceitaService(cliente: cliente);
    final receitas = await service.pesquisarReceitas('pizza');

    expect(receitas, isEmpty);
  });

  test('informa erro para status HTTP inválido', () async {
    final cliente = MockClient((request) async {
      return http.Response('erro', 500);
    });

    final service = ReceitaService(cliente: cliente);

    expect(service.listarReceitas, throwsA(isA<ReceitaServiceException>()));
  });

  test('informa erro para corpo incompatível', () async {
    final cliente = MockClient((request) async {
      return http.Response(jsonEncode({'dados': []}), 200);
    });

    final service = ReceitaService(cliente: cliente);

    expect(
      service.listarReceitas,
      throwsA(
        isA<ReceitaServiceException>().having(
          (erro) => erro.mensagem,
          'mensagem',
          'A resposta recebida não pôde ser interpretada.',
        ),
      ),
    );
  });

  test('distingue JSON inválido de falha de conexão', () async {
    final cliente = MockClient((request) async {
      return http.Response('{inválido', 200);
    });

    final service = ReceitaService(cliente: cliente);

    expect(
      service.listarReceitas,
      throwsA(
        isA<ReceitaServiceException>().having(
          (erro) => erro.mensagem,
          'mensagem',
          'A resposta recebida não pôde ser interpretada.',
        ),
      ),
    );
  });

  test('distingue tipos incompatíveis de falha de conexão', () async {
    final cliente = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'recipes': [
            {'id': 1.5},
          ],
        }),
        200,
      );
    });

    final service = ReceitaService(cliente: cliente);

    expect(
      service.listarReceitas,
      throwsA(
        isA<ReceitaServiceException>().having(
          (erro) => erro.mensagem,
          'mensagem',
          'A resposta recebida não pôde ser interpretada.',
        ),
      ),
    );
  });

  test('informa quando a requisição excede o tempo limite', () async {
    final cliente = MockClient((request) => Completer<http.Response>().future);
    final service = ReceitaService(
      cliente: cliente,
      tempoLimite: const Duration(milliseconds: 10),
    );

    expect(
      service.listarReceitas,
      throwsA(
        isA<ReceitaServiceException>().having(
          (erro) => erro.mensagem,
          'mensagem',
          'A solicitação demorou demais. Tente novamente.',
        ),
      ),
    );
  });

  test('informa falha de conexão separadamente', () async {
    final cliente = MockClient((request) async {
      throw http.ClientException('sem conexão');
    });
    final service = ReceitaService(cliente: cliente);

    expect(
      service.listarReceitas,
      throwsA(
        isA<ReceitaServiceException>().having(
          (erro) => erro.mensagem,
          'mensagem',
          'Verifique sua conexão e tente novamente.',
        ),
      ),
    );
  });
}
