import 'package:app_cripto_final/models/crypto_model.dart';
import 'package:app_cripto_final/viewmodels/crypto_list_viewmodel.dart';
import 'package:app_cripto_final/views/crypto_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  final TextEditingController _controller = TextEditingController();
  String _lastSuccessfulSearch = 'BTC,ETH,SOL,XRP,ADA,DOGE'; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoListViewModel>().fetchInitialCryptos();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<CryptoListViewModel>().searchCryptos(query);
      FocusScope.of(context).unfocus();
    }
  }

  void _showDetailSheet(Crypto crypto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CryptoDetailSheet(crypto: crypto),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CryptoListViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cotação de Criptos em Tempo Real')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 20),
            Expanded(child: _buildBody(viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Buscar por Símbolos (ex: BTC,ETH,SOL)',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _performSearch(_controller.text),
        ),
      ),
      onSubmitted: (value) => _performSearch(value),
    );
  }

  Widget _buildBody(CryptoListViewModel viewModel) {
    if (viewModel.state == ViewState.success) {
      _lastSuccessfulSearch = viewModel.cryptos.map((c) => c.symbol).join(',');
    }

    switch (viewModel.state) {
      case ViewState.loading:
        return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor));
      case ViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Erro: ${viewModel.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
          ),
        );
      
      case ViewState.empty:
        return const Center(
          child: Text(
            'Nenhuma criptomoeda encontrada com esse nome.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );

      case ViewState.success:
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildCryptoList(viewModel.cryptos);
            } else {
              final crossAxisCount = (constraints.maxWidth / 350).floor();
              return _buildCryptoGrid(viewModel.cryptos, crossAxisCount);
            }
          },
        );
      case ViewState.idle:
      default:
        return const Center(child: Text('Digite um símbolo para iniciar a busca.'));
    }
  }

  Widget _buildCryptoList(List<Crypto> cryptos) {
    return RefreshIndicator(
      onRefresh: () => context.read<CryptoListViewModel>().searchCryptos(
        _controller.text.trim().isEmpty ? _lastSuccessfulSearch : _controller.text
      ),
      child: ListView.builder(
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
          final crypto = cryptos[index];
          return _buildCryptoCard(crypto);
        },
      ),
    );
  }

  Widget _buildCryptoGrid(List<Crypto> cryptos, int crossAxisCount) {
    return RefreshIndicator(
      onRefresh: () => context.read<CryptoListViewModel>().searchCryptos(
        _controller.text.trim().isEmpty ? _lastSuccessfulSearch : _controller.text
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
          final crypto = cryptos[index];
          return _buildCryptoCard(crypto);
        },
      ),
    );
  }

  Widget _buildCryptoCard(Crypto crypto) {
    final color = crypto.percentChange24h >= 0
        ? Colors.greenAccent.shade400
        : Colors.redAccent;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: () => _showDetailSheet(crypto),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(crypto.symbol[0],
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(crypto.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        subtitle: Text('BRL: R\$ ${crypto.price.toStringAsFixed(2)} | USD: \$ ${crypto.priceUsd.toStringAsFixed(2)}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${crypto.percentChange24h.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}