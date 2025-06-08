import 'package:app_cripto_final/viewmodels/crypto_list_viewmodel.dart';
import 'package:app_cripto_final/views/crypto_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color primaryColor = Color(0xFF00BFFF);
const Color backgroundColor = Color(0xFF0A0A14);
const Color surfaceColor = Color(0xFF1C1C2D);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CryptoListViewModel(),
      child: MaterialApp(
        title: 'Cotação de Criptos em Tempo Real',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: backgroundColor,
            primaryColor: primaryColor,
            colorScheme: const ColorScheme.dark(
              primary: primaryColor,
              background: backgroundColor, // 'background' ainda é válido aqui no colorScheme
              surface: surfaceColor,
              onSurface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: surfaceColor,
              elevation: 2,
            ),
            cardTheme: CardThemeData(
              color: surfaceColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: surfaceColor,
            )),
        home: const CryptoListPage(),
      ),
    );
  }
}