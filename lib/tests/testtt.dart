import 'dart:math';

class VigenereCipher {
  String key;
  VigenereCipher(this.key);

  static const ukrAlphabet = 'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ';
  static const alphabetLength = 33;

  String encrypt(String input) {
    input = input.toUpperCase();
    key = key.replaceAll(' ', '').toUpperCase();

    String output = "";
    int j = 0;

    for (int i = 0; i < input.length; i++) {
      if (_isUkrainianLetter(input[i])) {
        int encryptedCharCode = (_ukrainianCharCode(input[i]) +
                _ukrainianCharCode(key[j % key.length])) %
            alphabetLength;
        output += _ukrainianCharFromCode(encryptedCharCode);
        j++;
      } else {
        output += input[i];
      }
    }
    return output;
  }

  String decrypt(String input) {
    input = input.toUpperCase();
    key = key.replaceAll(' ', '').toUpperCase();

    String output = "";
    int j = 0;

    for (int i = 0; i < input.length; i++) {
      if (_isUkrainianLetter(input[i])) {
        int decryptedCharCode = (_ukrainianCharCode(input[i]) -
                _ukrainianCharCode(key[j % key.length]) +
                alphabetLength) %
            alphabetLength;
        output += _ukrainianCharFromCode(decryptedCharCode);
        j++;
      } else {
        output += input[i];
      }
    }
    return output;
  }

  bool _isUkrainianLetter(String char) {
    return ukrAlphabet.contains(char);
  }

  int _ukrainianCharCode(String char) {
    return ukrAlphabet.indexOf(char);
  }

  String _ukrainianCharFromCode(int code) {
    return ukrAlphabet[code];
  }
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

int findKeyLength(String ciphertext) {
  int keyLength = 1;
  double maxIc = 0.0;
  for (int kl = 1; kl <= 15; kl++) {
    // Расширяем диапазон поиска длины ключа
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
  List<String> possibleKeys = [];
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
    possibleKeys.add(chiSqList[0].key); // Наиболее вероятный символ
  }

  return possibleKeys;
}

void analyzeCiphertext(String ciphertext) {
  ciphertext = ciphertext.replaceAll(
      RegExp(r'[^А-ЯЄІЇҐ]'), ''); // Удаление всех неалфавитных символов
  int keyLength = findKeyLength(ciphertext);
  List<String> possibleKeys = findPossibleKeys(ciphertext, keyLength);

  print('Довжина ключа: $keyLength');
  print('Можливий ключ: ${possibleKeys.join()}');
  VigenereCipher cipher = VigenereCipher(possibleKeys.join());
  String decryptedText = cipher.decrypt(ciphertext);
  print('Дешифрованный текст: $decryptedText');
}

void main() {
  String ciphertext =
      "МЕБ ПТД, ФВФ ЬШЇЕФ - И ГБОЇ ВБТНЕ,ГҐУФ Ц ЬФБН ЧХАЯЕХ? ЖШҐГХАЙ РҐДЯНИІ?Щ ПЖЛЇБЩ, А ЬЖПДДП БИМЯСЯ ВБ ЛБЯЩ.ТШМФ… ОТЧПТС… ГПВЙ ЛНХФХАЯ,О АЦЄВШ УОМ'НИФ, БЯФХЯФ ЧШЖ'МКЄ…Х АФЕНД ГНЬЯРШАБ ЖШСЗФ ДЯЧЇЇДКЯ.К ЕЯВБАЮН ФВЄКВБ, ДЮ ОШБЙР РМШНБТЩГ,Х ЧЙЦШ ЦШБРЯВЕ, ДЮ ОШБЙР ҐИМЯЗ,ЖЯҐЩШЬЩЕЩ А АГГЩІ, Н ЕЗ, УХАЯАДЯЧЇ,ЖЯ ЕФВХФАТ ЕРПҐ РДПТДН АГНЖИДЕЩ,ФФЮПФУ ХВҐЯМШГЛМД П ЄЄЩГЛГЗ, РҐЗЕФІЇЩ Ь ТВПШ ЛФУЯЛЕФ И УҐУРЙ МНМСП,ЙЯ ЮОА ЖНБЯЩГЮГІ, УНҐ ВЯСЯ ЕШІНЛЯ,Х ВКУ НМА, ШЄ ЛЖПФ Ґ УНЧЯЬШ ВШЇЕАЗ;ІФ РХЇЇМЬ АШУ ЯБОЦ!.. СЛАҐЇ ДЯЧІФПКСГЛ,ЙЯ Ґ ЄҐЯІЯБ, У ЕБЧЕПЄЇ, ДЯЧІФПКСГЛ У ЄЙЄВЬ,ИАЩМОНГ ЕНУХ УҐБО, ВВ СЯ Т ВКЙБХЕЯФ.АГБОЖ ТУМА ИФ БОҐ, ІУ ҐАГШВЛ Ґ КЄПУЯМ?Й ВБ ФТЗЕЯЯФЮ, Ч УУ РЯБГГО -ВЧЕЩ Ї ЬФЮФ АНЕЗ, ІК УР ЬР ХВҐАГШ?";
  analyzeCiphertext(ciphertext);
}
