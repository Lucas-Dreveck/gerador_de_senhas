import 'dart:math';

class PasswordGenerator {
  static String generate({
    int letters = 4,
    int numbers = 2,
    int special = 2,
  }) {
    const letterSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numberSet = '0123456789';
    const specialSet = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

    final rand = Random.secure();
    String getRandom(String chars, int count) =>
        List.generate(count, (_) => chars[rand.nextInt(chars.length)]).join();

    final lettersList = getRandom(letterSet, letters).split('');
    final numbersList = getRandom(numberSet, numbers).split('');
    final specialsList = getRandom(specialSet, special).split('');

    final combined = <String>[];
    final maxLength = [lettersList.length, numbersList.length, specialsList.length].reduce(max);

    for (int i = 0; i < maxLength; i++) {
      if (i < lettersList.length) combined.add(lettersList[i]);
      if (i < numbersList.length) combined.add(numbersList[i]);
      if (i < specialsList.length) combined.add(specialsList[i]);
    }

    combined.shuffle();
    return combined.join();
  }
}