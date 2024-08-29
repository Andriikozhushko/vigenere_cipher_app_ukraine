import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/vigenere.dart';
import '../widgets/actions_buttons_widget.dart';
import '../widgets/crypto_textfield_widget.dart';
import '../widgets/result_container_widget.dart';

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});

  @override
  EncryptionScreenState createState() => EncryptionScreenState();
}

class EncryptionScreenState extends State<EncryptionScreen> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = '';

  void _encryptText(String text) {
    final key = _keyController.text;

    final cipher = VigenereCipher(key);
    final encrypted = cipher.encrypt(text);

    setState(() {
      _result = encrypted;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Результат скопійовано в буфер обміну!')),
      );
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final file = File(filePath);
        final content = await file.readAsString();
        setState(() {
          _textController.text = content;
          _encryptText(content); // Зашифровка текста из файла
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Шифрування',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
              ElevatedButton(
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Вибрати файл',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              crypto_textfield_widget(
                  controller: _textController,
                  hint: 'Введіть текст для шифрування',
                  maxLines: 5),
              const SizedBox(height: 16),
              crypto_textfield_widget(
                  controller: _keyController,
                  hint: 'Введіть ключ шифрування',
                  maxLines: 1),
              const SizedBox(height: 20),
              ActionButtonsWidget(
                onEncryptText: () {
                  final text = _textController.text;
                  _encryptText(text);
                },
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
