import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/crypto_analysis_logic.dart';
import '../widgets/crypto_textfield_widget.dart';
import '../widgets/result_text_widget.dart';

class CryptoAnalysisScreen extends StatefulWidget {
  const CryptoAnalysisScreen({super.key});

  @override
  CryptoAnalysisScreenState createState() => CryptoAnalysisScreenState();
}

class CryptoAnalysisScreenState extends State<CryptoAnalysisScreen> {
  final _ciphertextController = TextEditingController();
  String _analysisResult = '';

  void _analyzeCiphertext() {
    final ciphertext = _ciphertextController.text;
    print("Ciphertext: $ciphertext"); // Для отладки
    final result = analyzeCiphertext(ciphertext);
    print("Analysis Result: $result"); // Для отладки

    setState(() {
      _analysisResult = result;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _analysisResult)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Результат скопійовано в буфер обміну!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Криптоаналіз шифру Віженера',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              crypto_textfield_widget(
                controller: _ciphertextController,
                hint: 'Введите шифротекст для анализа',
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _analyzeCiphertext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Аналізувати',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              if (_analysisResult.isNotEmpty)
                ResultTextWidget(
                    text: _analysisResult), // Используйте новый виджет
            ],
          ),
        ),
      ),
      floatingActionButton: _analysisResult.isNotEmpty
          ? FloatingActionButton(
              onPressed: _copyToClipboard,
              backgroundColor: Colors.blueGrey[600],
              tooltip: 'Скопіювати результат',
              child: const Icon(
                Icons.copy,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
