import "string_extension.dart";

extension IntExtension on int {
  String i18nPlural(
    String key, {
    String zero,
    String one,
    String other,
    Map<String, dynamic> variables,
  }) {
    String baseToUse = zero;
    if (this == 1) {
      baseToUse = one;
    } else if (this > 1) {
      baseToUse = other;
    }

    return baseToUse
        .i18n(key, variables: variables)
        .replaceAll("#", this.toString());
  }
}
