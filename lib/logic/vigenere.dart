class VigenereCipher {
  String key;
  VigenereCipher(this.key);

  // Украинский алфавит
  static const ukrAlphabet = 'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ';
  static const alphabetLength = 33;

  // Функция шифрования
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

  // Функция дешифрования
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

  // Проверка, является ли символ украинской буквой
  bool _isUkrainianLetter(String char) {
    return ukrAlphabet.contains(char);
  }

  // Преобразование украинской буквы в код (0-32)
  int _ukrainianCharCode(String char) {
    return ukrAlphabet.indexOf(char);
  }

  // Преобразование кода (0-32) в украинскую букву
  String _ukrainianCharFromCode(int code) {
    return ukrAlphabet[code];
  }
}
