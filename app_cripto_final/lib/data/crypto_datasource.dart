import 'package:app_cripto_final/core/http_service.dart';
import 'dart:convert';

class CryptoDataSource {
  final HttpService _httpService = HttpService();
  final String _apiKey = 'd515409d-ed33-4fe0-b10d-fe60632df1f6';
  final String _baseUrl =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';

  // O método agora recebe a moeda para a qual deve converter
  Future<Map<String, dynamic>> fetchQuotes(List<String> symbols, String convertCurrency) async {
    if (_apiKey == 'SUA_CHAVE_API_VÁLIDA_AQUI') {
      throw Exception('Chave de API nao configurada');
    }

    final url = Uri.parse('$_baseUrl?symbol=${symbols.join(',')}&convert=$convertCurrency');

    final response = await _httpService.get(
      url,
      headers: {
        'X-CMC_PRO_API_KEY': _apiKey,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception('Falha na API: ${error['status']['error_message']}');
    }
  }
}