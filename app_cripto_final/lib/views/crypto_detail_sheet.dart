import 'package:app_cripto_final/models/crypto_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class CryptoDetailSheet extends StatelessWidget {
  final Crypto crypto;
  const CryptoDetailSheet({super.key, required this.crypto});

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '${crypto.name} (${crypto.symbol})',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 0.5),

          _buildDetailRow(
              'Preço (BRL):', 'R\$ ${crypto.price.toStringAsFixed(2)}'),
          _buildDetailRow(
              'Preço (USD):', 'US\$ ${crypto.priceUsd.toStringAsFixed(2)}'),
          _buildDetailRow(
            'Variação em 24h:',
            '${crypto.percentChange24h.toStringAsFixed(2)}%',
            valueColor: crypto.percentChange24h >= 0
                ? Colors.greenAccent.shade400
                : Colors.redAccent,
          ),
          _buildDetailRow('Adicionada em:', _formatDate(crypto.dateAdded)),
          _buildDetailRow(
              'Volume em 24h:', 'R\$ ${crypto.volume24h.toStringAsFixed(0)}'),
          _buildDetailRow('Capitalização de Mercado:',
              'R\$ ${crypto.marketCap.toStringAsFixed(0)}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade400)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: valueColor ?? Colors.white)),
        ],
      ),
    );
  }
}