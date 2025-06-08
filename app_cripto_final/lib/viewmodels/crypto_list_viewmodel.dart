import 'package:app_cripto_final/models/crypto_model.dart';
import 'package:app_cripto_final/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error, empty }

class CryptoListViewModel extends ChangeNotifier {
  final CryptoRepository _repository = CryptoRepository();

  final String _defaultSymbols = 'BTC,ETH,SOL,BNB,BCH,MKR,AAVE,DOT,SUI,ADA,XRP,TIA,NEO,NEAR,PENDLE,RENDER,LINK,TON,XAI,SEI,IMX,ETHFI,UMA,SUPER,FET,USUAL,GALA,PAAL,AERO';

  List<Crypto> _cryptos = [];
  List<Crypto> get cryptos => _cryptos;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> fetchInitialCryptos() async {
    await searchCryptos(_defaultSymbols);
  }

  Future<void> searchCryptos(String symbols) async {
    final symbolsToSearch = symbols.trim().isEmpty ? _defaultSymbols : symbols;

    _setState(ViewState.loading);
    try {
      final symbolList =
          symbolsToSearch.split(',').map((s) => s.trim().toUpperCase()).toList();
      final result = await _repository.getCryptoQuotes(symbolList);

      if (result.isEmpty) {
        _cryptos = [];
        _setState(ViewState.empty);
      } else {
        _cryptos = result;
        _setState(ViewState.success);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _setState(ViewState.error);
    }
  }
}