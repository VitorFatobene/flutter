import 'dart:async';
import 'dart:convert';

import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:http/http.dart' as http;

abstract class ReceitaApi {
  Future<List<Receita>> listarReceitas();

  Future<List<Receita>> pesquisarReceitas(String termo);
}

class ReceitaServiceException implements Exception {
  final String mensagem;

  const ReceitaServiceException(this.mensagem);

  @override
  String toString() => mensagem;
}

class ReceitaService implements ReceitaApi {
  final http.Client cliente;
  final Duration tempoLimite;

  ReceitaService({
    http.Client? cliente,
    this.tempoLimite = const Duration(seconds: 10),
  }) : cliente = cliente ?? http.Client();

  @override
  Future<List<Receita>> listarReceitas() {
    final uri = Uri.https('dummyjson.com', '/recipes', {'limit': '20'});
    return _buscar(uri);
  }

  @override
  Future<List<Receita>> pesquisarReceitas(String termo) {
    final uri = Uri.https('dummyjson.com', '/recipes/search', {'q': termo});
    return _buscar(uri);
  }

  Future<List<Receita>> _buscar(Uri uri) async {
    try {
      final resposta = await cliente.get(uri).timeout(tempoLimite);

      if (resposta.statusCode != 200) {
        throw const ReceitaServiceException(
          'Não foi possível carregar as receitas.',
        );
      }

      final corpo = jsonDecode(resposta.body);

      if (corpo is! Map<String, dynamic> || corpo['recipes'] is! List) {
        throw const ReceitaServiceException(
          'A resposta recebida não pôde ser interpretada.',
        );
      }

      final itens = corpo['recipes'] as List;

      return itens.map((item) {
        if (item is! Map) {
          throw const ReceitaServiceException(
            'A resposta recebida não pôde ser interpretada.',
          );
        }

        return Receita.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } on ReceitaServiceException {
      rethrow;
    } on TimeoutException {
      throw const ReceitaServiceException(
        'A solicitação demorou demais. Tente novamente.',
      );
    } on FormatException {
      throw const ReceitaServiceException(
        'A resposta recebida não pôde ser interpretada.',
      );
    } on TypeError {
      throw const ReceitaServiceException(
        'A resposta recebida não pôde ser interpretada.',
      );
    } catch (_) {
      throw const ReceitaServiceException(
        'Verifique sua conexão e tente novamente.',
      );
    }
  }
}
