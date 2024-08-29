import 'dart:math';

import '../logic/vigenere.dart';

String analyzeCiphertext(String ciphertext) {
  String filteredCiphertext = ciphertext.replaceAll(RegExp(r'[^А-ЯЄІЇҐ]'), '');
  int keyLength = findKeyLength(filteredCiphertext);
  List<String> possibleKeys = findPossibleKeys(filteredCiphertext, keyLength);

  VigenereCipher cipher = VigenereCipher(possibleKeys.join());
  String decryptedText = cipher.decrypt(ciphertext);

  return 'Довжина ключа: $keyLength\nМожливий ключ: ${possibleKeys.join()}\nДешифрований текст: $decryptedText';
}

int findKeyLength(String ciphertext) {
  int keyLength = 1;
  double maxIc = 0.0;
  for (int kl = 1; kl <= 15; kl++) {
    double averageIc = 0.0;
    int count = 0;
    for (int i = 0; i < kl; i++) {
      String subsequence = '';
      for (int j = i; j < ciphertext.length; j += kl) {
        if (VigenereCipher.ukrAlphabet.contains(ciphertext[j])) {
          subsequence += ciphertext[j];
        }
      }
      if (subsequence.isNotEmpty) {
        averageIc += calculateIndexOfCoincidence(subsequence);
        count++;
      }
    }
    if (count > 0) {
      averageIc /= count;
    }

    if (averageIc > maxIc) {
      maxIc = averageIc;
      keyLength = kl;
    }
  }
  return keyLength;
}

List<String> findPossibleKeys(String ciphertext, int keyLength) {
  Set<String> possibleKeys = {};
  final letterFrequency = {
    'А': 0.0801,
    'Б': 0.0159,
    'В': 0.0454,
    'Г': 0.0167,
    'Ґ': 0.0001,
    'Д': 0.0298,
    'Е': 0.0845,
    'Є': 0.0004,
    'Ж': 0.0094,
    'З': 0.0165,
    'И': 0.0735,
    'І': 0.0708,
    'Ї': 0.0002,
    'Й': 0.0070,
    'К': 0.0349,
    'Л': 0.0440,
    'М': 0.0321,
    'Н': 0.0670,
    'О': 0.1080,
    'П': 0.0233,
    'Р': 0.0473,
    'С': 0.0421,
    'Т': 0.0537,
    'У': 0.0270,
    'Ф': 0.0013,
    'Х': 0.0092,
    'Ц': 0.0044,
    'Ч': 0.0133,
    'Ш': 0.0073,
    'Щ': 0.0026,
    'Ь': 0.0230,
    'Ю': 0.0020,
    'Я': 0.0184
  };

  for (int i = 0; i < keyLength; i++) {
    String subsequence = '';
    for (int j = i; j < ciphertext.length; j += keyLength) {
      if (VigenereCipher.ukrAlphabet.contains(ciphertext[j])) {
        subsequence += ciphertext[j];
      }
    }

    List<MapEntry<String, double>> chiSqList = [];

    for (int k = 0; k < VigenereCipher.alphabetLength; k++) {
      double chiSq = 0.0;
      Map<String, int> freqCount = {};
      for (int j = 0; j < subsequence.length; j++) {
        String shiftedChar = VigenereCipher.ukrAlphabet[
            (VigenereCipher.ukrAlphabet.indexOf(subsequence[j]) -
                    k +
                    VigenereCipher.alphabetLength) %
                VigenereCipher.alphabetLength];
        freqCount[shiftedChar] = (freqCount[shiftedChar] ?? 0) + 1;
      }

      letterFrequency.forEach((char, expectedFreq) {
        double observedFreq = (freqCount[char] ?? 0).toDouble();
        chiSq += pow(observedFreq - expectedFreq * subsequence.length, 2) /
            (expectedFreq * subsequence.length);
      });

      chiSqList.add(MapEntry(VigenereCipher.ukrAlphabet[k], chiSq));
    }

    chiSqList.sort((a, b) => a.value.compareTo(b.value));
    possibleKeys.add(chiSqList[0].key);
  }

  return possibleKeys.toList();
}

double calculateIndexOfCoincidence(String text) {
  int n = text.length;
  Map<String, int> frequencies = {};
  for (int i = 0; i < n; i++) {
    String char = text[i];
    if (VigenereCipher.ukrAlphabet.contains(char)) {
      frequencies[char] = (frequencies[char] ?? 0) + 1;
    }
  }

  double ic = 0.0;
  frequencies.forEach((char, freq) {
    ic += freq * (freq - 1);
  });

  ic /= n * (n - 1).toDouble();
  return ic;
}
