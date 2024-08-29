import 'package:flutter/material.dart';

class crypto_textfield_widget extends StatelessWidget {
  const crypto_textfield_widget({
    super.key,
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
          ),
          style: const TextStyle(color: Colors.white),
          maxLines: maxLines,
        ),
      ),
    );
  }
}
