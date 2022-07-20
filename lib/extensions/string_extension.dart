import 'package:diacritic/diacritic.dart';

extension StringExtension on String {
  String get enumValue => this.toString().split(".").last;

  String get upperCase => this.toUpperCase();
  String get lowerCase => this.toLowerCase();
  String get trim => this.trim();
  String get lowerCaseTrim => this.toLowerCase().trim();

  bool searchContains(String searchString) => removeDiacritics(
        this.lowerCaseTrim,
      ).contains(
        removeDiacritics(
          searchString.lowerCaseTrim,
        ),
      );

  String maxLength(int maxLength, {bool withTrailingDots = true}) =>
      this.length > maxLength
          ? this.substring(0, withTrailingDots ? maxLength : maxLength - 3) +
              "${withTrailingDots ? " ..." : ""}"
          : this;

  String get asUrl {
    return removeDiacritics(this.lowerCaseTrim)
        .replaceAll(RegExp(r"[!?]"), "")
        .replaceAll(RegExp(' +'), '-');
  }

  String i18n(
    String key, {
    Map<String, dynamic> variables,
  }) {
    String result = this;

    if (variables != null) {
      for (final key in variables.keys) {
        result = result.replaceAll("\$$key", variables[key]);
      }
    }

    return result;
  }
}
