import 'dart:developer';

import 'package:validate/validate.dart';

bool isPasswordValid(String value) => value.length > 5;
bool isPhoneValid(String value) {
  value = value.replaceAll(RegExp(r"[^0-9]"), "");
  value = "+" + value;
  log(value);
  return value.length == 14;
}

bool isEmailValid(String value) {
  try {
    Validate.isEmail(value.trim());
  } catch (e) {
    return false;
  }
  return true;
}

bool isUrlValid(String url) {
  final String urlPattern =
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  final regExp = RegExp(urlPattern, caseSensitive: false);
  return regExp.hasMatch(url);
}

String validateEmail(String value) {
  if (isEmailValid(value)) return null;
  return 'O e-mail informado é inválido!';
}

String validatePhone(String value) {
  if (isPhoneValid(value)) return null;
  return 'Insira um número de celular válido.';
}

String validatePassword(String value) {
  if (isPasswordValid(value)) return null;
  return 'A senha precisa ter pelo menos 6 caracteres';
}
