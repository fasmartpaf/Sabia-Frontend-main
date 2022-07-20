Future<void> delayFor({
  int seconds,
  int milliseconds,
}) =>
    Future.delayed(Duration(
      seconds: seconds ?? 1,
      milliseconds: milliseconds ?? 0,
    ));

Future<void> delayUntil(DateTime dateLimit, Function fn) async {
  if (dateLimit.isAfter(DateTime.now())) {
    await Future.delayed(dateLimit.difference(DateTime.now()), fn);
  } else {
    fn();
  }
}
