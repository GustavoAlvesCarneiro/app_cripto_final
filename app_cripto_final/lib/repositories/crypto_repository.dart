import 'package:app_cripto_final/data/crypto_datasource.dart';
import 'package:app_cripto_final/models/crypto_model.dart';

class CryptoRepository {
  final CryptoDataSource _dataSource = CryptoDataSource();

  Future<List<Crypto>> getCryptoQuotes(List<String> symbols) async {
    try {
      final brlResponse = await _dataSource.fetchQuotes(symbols, 'BRL');
      final brlDataMap = brlResponse['data'] as Map<String, dynamic>?;

      final usdResponse = await _dataSource.fetchQuotes(symbols, 'USD');
      final usdDataMap = usdResponse['data'] as Map<String, dynamic>?;

      if (brlDataMap == null || usdDataMap == null) {
        return []; 
      }

      final List<Crypto> cryptos = [];

      brlDataMap.forEach((symbol, brlCryptoJson) {
        if (usdDataMap.containsKey(symbol)) {
          final usdCryptoJson = usdDataMap[symbol];
          
          final combinedJson = Map<String, dynamic>.from(brlCryptoJson);
          
          combinedJson['quote']['USD'] = usdCryptoJson['quote']['USD'];

          cryptos.add(Crypto.fromJson(combinedJson));
        }
      });
      
      return cryptos;
    } catch (e) {
      rethrow;
    }
  }
}