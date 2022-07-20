String displayPhoneFromString(String phone) {
  if (phone.isEmpty) return "";
  if (!phone.contains("+55")) {
    return phone;
  }

  final number = phone.replaceAll("+55", "");
  return "(${number.substring(0, 2)}) ${number.substring(2, 7)}-${number.substring(7)}";
}

String phoneLastEightDigits(String phone) =>
    phone.substring(phone.length - 8, phone.length - 1);
