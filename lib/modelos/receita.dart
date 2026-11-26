class Receita {
  final int id;
  final String nome;
  final List<String> ingredientes;
  final List<String> instrucoes;
  final String? imagem;
  final int? tempoPreparo;
  final int? tempoCozimento;
  final int? porcoes;
  final double? avaliacao;
  final List<String> tiposRefeicao;
  final String? dificuldade;
  final String? culinaria;
  final int? caloriasPorPorcao;
  final List<String> tags;
  final int? quantidadeAvaliacoes;

  const Receita({
    required this.id,
    required this.nome,
    required this.ingredientes,
    required this.instrucoes,
    required this.imagem,
    required this.tempoPreparo,
    required this.tempoCozimento,
    required this.porcoes,
    required this.avaliacao,
    required this.tiposRefeicao,
    this.dificuldade,
    this.culinaria,
    this.caloriasPorPorcao,
    this.tags = const [],
    this.quantidadeAvaliacoes,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    final id = json['id'];

    if (id is! int) {
      throw const FormatException('Receita sem identificador válido.');
    }

    final nomeRecebido = json['name'];
    final imagemRecebida = json['image'];

    return Receita(
      id: id,
      nome: nomeRecebido is String && nomeRecebido.trim().isNotEmpty
          ? nomeRecebido
          : 'Receita sem nome',
      ingredientes: _listaDeTextos(json['ingredients']),
      instrucoes: _listaDeTextos(json['instructions']),
      imagem: imagemRecebida is String && imagemRecebida.trim().isNotEmpty
          ? imagemRecebida
          : null,
      tempoPreparo: _inteiroOuNulo(json['prepTimeMinutes']),
      tempoCozimento: _inteiroOuNulo(json['cookTimeMinutes']),
      porcoes: _inteiroOuNulo(json['servings']),
      avaliacao: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : null,
      tiposRefeicao: _listaDeTextos(json['mealType']),
      dificuldade: _textoOuNulo(json['difficulty']),
      culinaria: _textoOuNulo(json['cuisine']),
      caloriasPorPorcao: _inteiroOuNulo(json['caloriesPerServing']),
      tags: _listaDeTextos(json['tags']),
      quantidadeAvaliacoes: _inteiroOuNulo(json['reviewCount']),
    );
  }

  int? get tempoTotal {
    if (tempoPreparo == null || tempoCozimento == null) {
      return null;
    }

    return tempoPreparo! + tempoCozimento!;
  }

  static int? _inteiroOuNulo(dynamic valor) {
    return valor is int ? valor : null;
  }

  static String? _textoOuNulo(dynamic valor) {
    return valor is String && valor.trim().isNotEmpty ? valor : null;
  }

  static List<String> _listaDeTextos(dynamic valor) {
    if (valor is! List) {
      return [];
    }

    return valor.whereType<String>().toList();
  }
}
