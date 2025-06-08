class Crypto {
  final String symbol;
  final String name;
  final double price; 
  final double priceUsd; 
  final String dateAdded; 
  final double percentChange24h;
  final double volume24h;
  final double marketCap;

  Crypto({
    required this.symbol,
    required this.name,
    required this.price,
    required this.priceUsd, 
    required this.dateAdded, 
    required this.percentChange24h,
    required this.volume24h,
    required this.marketCap,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'];
    final quoteBrl = quote['BRL'];
    final quoteUsd = quote['USD'];

    return Crypto(
      symbol: json['symbol'],
      name: json['name'],
      dateAdded: json['date_added'], 
      price: quoteBrl['price']?.toDouble() ?? 0.0,
      priceUsd: quoteUsd['price']?.toDouble() ?? 0.0,
      percentChange24h: quoteUsd['percent_change_24h']?.toDouble() ?? 0.0,
      volume24h: quoteBrl['volume_24h']?.toDouble() ?? 0.0,
      marketCap: quoteBrl['market_cap']?.toDouble() ?? 0.0,
    );
  }
}