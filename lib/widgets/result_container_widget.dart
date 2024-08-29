import 'package:flutter/material.dart';

class result_container_widget extends StatelessWidget {
  const result_container_widget({
    super.key,
    required String result,
  }) : _result = result;

  final String _result;

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
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Результат: $_result',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
