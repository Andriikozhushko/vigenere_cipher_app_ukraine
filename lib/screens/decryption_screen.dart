import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/vigenere.dart';
import '../widgets/crypto_textfield_widget.dart';
import '../widgets/result_container_widget.dart';

class DecryptionScreen extends StatefulWidget {
  const DecryptionScreen({super.key});

  @override
  DecryptionScreenState createState() => DecryptionScreenState();
}

class DecryptionScreenState extends State<DecryptionScreen> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = '';

  void _decryptText() {
    final text = _textController.text;
    final key = _keyController.text;

    final cipher = VigenereCipher(key);
    final decrypted = cipher.decrypt(text);

    setState(() {
      _result = decrypted;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Результат скопійовано в буфер обміну!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Дешифрування',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                controller: _textController,
                hint: 'Введіть текст для дешифрування',
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              crypto_textfield_widget(
                controller: _keyController,
                hint: 'Введіть ключ дешифрування',
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _decryptText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Розшифрувати',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              result_container_widget(result: _result),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _copyToClipboard,
        backgroundColor: Colors.blueGrey[600],
        tooltip: 'Скопіювати результат',
        child: const Icon(
          Icons.copy,
          color: Colors.white,
        ),
      ),
    );
  }
}
