import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/textfield_histogram_widget.dart';

class StylishHistogramPage extends StatefulWidget {
  const StylishHistogramPage({super.key});

  @override
  StylishHistogramPageState createState() => StylishHistogramPageState();
}

class StylishHistogramPageState extends State<StylishHistogramPage> {
  String _text = '';
  Map<String, int> _frequencyMap = {};

  void _updateFrequencyMap(String text) {
    final frequencyMap = <String, int>{};
    final validCharacters =
        RegExp(r'[а-яА-ЯіІїЇєЄ]'); // Регулярное выражение для украинских букв

    for (var char in text
        .toLowerCase()
        .split('')
        .where((char) => validCharacters.hasMatch(char))) {
      frequencyMap[char] = (frequencyMap[char] ?? 0) + 1;
    }

    setState(() {
      _frequencyMap = frequencyMap;
    });
  }

  List<BarChartGroupData> _generateBarGroups() {
    final barGroups = <BarChartGroupData>[];
    int index = 0;
    _frequencyMap.forEach((char, frequency) {
      barGroups.add(BarChartGroupData(
        x: index,
        barsSpace: 12, // Увеличиваем расстояние между столбцами
        barRods: [
          BarChartRodData(
            toY: frequency.toDouble(),
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      ));
      index++;
    });
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Гістограма',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            textfield_histogram_widget(
                hint: 'Введите текст для анализа',
                onChanged: (text) {
                  setState(() {
                    _text = text;
                    _updateFrequencyMap(_text);
                  });
                }),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: _frequencyMap.length *
                          47.0, // Учитываем дополнительное пространство между столбцами
                      maxWidth: _frequencyMap.length * 47.0,
                      maxHeight: 300,
                    ),
                    child: BarChart(
                      BarChartData(
                        maxY: _frequencyMap.isNotEmpty
                            ? _frequencyMap.values
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble() +
                                3
                            : 1,
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: _generateBarGroups(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Убираем боковые цифры
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles:
                                  true, // Оставляем только буквы под столбцами
                              reservedSize: 40, // Оставляем место для титлов
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    _frequencyMap.keys.elementAt(value.toInt()),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18, // Увеличиваем размер шрифта
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true, // Включаем верхние титлы
                              reservedSize: 40, // Оставляем место для титлов
                              getTitlesWidget: (double value, TitleMeta meta) {
                                // Пример текста для верхних титлов (можно настроить)
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    _frequencyMap.isNotEmpty
                                        ? _frequencyMap.keys
                                            .elementAt(value.toInt())
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Убираем правые цифры
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3), // Уменьшаем паддинги в тултипе
                            tooltipBgColor: Colors.black54,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toInt()}', // Показываем только цифры
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                          touchCallback: (FlTouchEvent event,
                              BarTouchResponse? response) {},
                          handleBuiltInTouches: true,
                          allowTouchBarBackDraw: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
