import 'package:atividade_receitas_professor/modelos/receita.dart';
import 'package:flutter/foundation.dart';

class FavoritosController extends ChangeNotifier {
  final List<Receita> _receitas = [];

  List<Receita> get receitas => List.unmodifiable(_receitas);

  bool contem(int id) {
    return _receitas.any((receita) => receita.id == id);
  }

  void adicionar(Receita receita) {
    if (contem(receita.id)) {
      return;
    }

    _receitas.add(receita);
    notifyListeners();
  }

  void remover(int id) {
    final quantidadeAnterior = _receitas.length;
    _receitas.removeWhere((receita) => receita.id == id);

    if (_receitas.length != quantidadeAnterior) {
      notifyListeners();
    }
  }

  void alternar(Receita receita) {
    if (contem(receita.id)) {
      remover(receita.id);
    } else {
      adicionar(receita);
    }
  }
}
