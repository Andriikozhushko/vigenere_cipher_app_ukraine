import 'package:flutter/material.dart';

class homescreen_buttons extends StatelessWidget {
  const homescreen_buttons({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
    required this.screen,
  });

  final BuildContext context;
  final String title;
  final IconData icon;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width:
            (MediaQuery.of(context).size.width - 48) / 2, // Две кнопки в строку
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
