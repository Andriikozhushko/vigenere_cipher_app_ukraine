import 'package:flutter/material.dart';

import '../widgets/home_screen_buttons_widget.dart';
import 'crypto_analysis_screen.dart';
import 'decryption_screen.dart';
import 'encryption_screen.dart';
import 'histogram_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 120),
            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage('assets/img/avatar.png'), // Путь к изображению
            ),
            const SizedBox(height: 16),
            const Text(
              'АНДРІЙ КОЖУШКО',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'ФІТ 3-12',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
            const Text(
              'КIБЕРБЕЗПЕКА',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
            const Text(
              'КМЗІ - ЛАБОРАТОРНА РОБОТА 1',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  homescreen_buttons(
                      context: context,
                      title: 'Шифрування',
                      icon: Icons.lock,
                      screen: EncryptionScreen()),
                  homescreen_buttons(
                      context: context,
                      title: 'Дешифрування',
                      icon: Icons.lock_open,
                      screen: DecryptionScreen()),
                  homescreen_buttons(
                      context: context,
                      title: 'Криптоаналіз',
                      icon: Icons.analytics,
                      screen: CryptoAnalysisScreen()),
                  homescreen_buttons(
                      context: context,
                      title: 'Гістограма',
                      icon: Icons.bar_chart,
                      screen: StylishHistogramPage()),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/img/univer_logo.png',
              width: 200,
            ),
            const Text(
              'Торгово-економічний університет',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
