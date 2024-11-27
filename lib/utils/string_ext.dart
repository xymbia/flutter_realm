extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String abbreviateNumber(int value) {
    if (value < 1000) {
      return "$value";
    }
    if (value < 1000000) {
      return "${(value / 1000).toStringAsFixed(2)}K";
    }
    if (value < 1000000000) {
      return "${(value / 1000000).toStringAsFixed(2)}M";
    }
    return "${(value / 1000000000).toStringAsFixed(2)}B";
  }

  (bool isLengthValid, bool hasUpperCase, bool hasNumber, bool hasUniqueWord)
      get validatePassword {
    return (
      length >= 8,
      contains(RegExp(r'[A-Z]')),
      contains(RegExp(r'[0-9]')),
      contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
    );
  }

  bool validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool validateUrl(String url) {
    RegExp regExp = RegExp(
        r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}(:[0-9]{1,5})?(\/.*)?$');

    return regExp.hasMatch(url) || url.isEmpty;
  }
}
