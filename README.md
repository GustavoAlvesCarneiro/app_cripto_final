# App Cripto - Flutter
# Gustavo Alves Carneiro RA:23202882-2

Software feito em Flutter com arquitetura MVVM (Model-View-ViewModel) que consome a CoinMarketCap API para exibir informações em tempo real sobre criptomoedas, permitindo a busca de múltiplas moedas por símbolo (ex: BTC, ETH) e exibindo os preços em BRL, além da variação percentual nas últimas 24 horas.

# Como executar?
É necessário ter instalado Flutter SDK (versão >= 3.10.0), Dart SDK, Android Studio / VS Code com emulador e conta e API key da CoinMarketCap

# Feito isso execute os seguintes comandos:
1. Clone o repositório:
git clone https://github.com/GustavoAlvesCarneiro/app_cripto_final
cd app_cripto_final

2. Instale as dependências:
flutter pub get

3. Configure a chave da API:
Abra o arquivo:
lib/data/crypto_datasource.dart
E substitua a key atual por uma nova chave gerada na API CoinMarketCap

4. Execute o software:
flutter run
