import 'dart:async';

/// Map of functions currently being debounced.
Map<Function, _DebounceTimer> debouncesList = <Function, _DebounceTimer>{};

/// A collection of of static functions to debounce calls to a [action] function.
class Debounce {
  static void run(
    Function action, {
    Duration timeout = const Duration(milliseconds: 500),
  }) {
    duration(timeout, action);
  }

  /// Calls [duration] with a timeout specified in milliseconds.
  static void milliseconds(
    int timeoutMs,
    Function action,
  ) {
    duration(
      Duration(milliseconds: timeoutMs),
      action,
    );
  }

  /// Calls [duration] with a timeout specified in seconds.
  static void seconds(
    int timeoutSeconds,
    Function target,
  ) {
    duration(
      Duration(seconds: timeoutSeconds),
      target,
    );
  }

  /// Calls [action] after a [timeout] duration
  ///
  /// Repeated calls to [duration] (or any debounce operation in this library)
  /// with the same [Function action] will reset the specified [timeout].
  static void duration(
    Duration timeout,
    Function action,
  ) {
    if (debouncesList.containsKey(action)) {
      debouncesList[action].cancel();
    }

    final _DebounceTimer timer = _DebounceTimer(
      timeout,
      action,
    );

    debouncesList[action] = timer;
  }

  /// Run a function which is already debounced (queued to be run later),
  /// but run it now. This also cancels and clears out the timeout for
  /// that function.
  /// Reurns [true] if a debounced function has been executed and cleared
  static bool runAndClear(
    Function target,
  ) {
    if (debouncesList.containsKey(target)) {
      debouncesList[target].runNow();
      debouncesList.remove(target);
      return true;
    }
    return false;
  }

  /// Clear a function that has been debounced. Returns [true] if
  /// a debounced function has been removed.
  static bool clear(Function target) {
    if (debouncesList.containsKey(target)) {
      debouncesList[target].cancel();
      debouncesList.remove(target);
      return true;
    }
    return false;
  }
}

// _DebounceTimer allows us to keep track of the target function
// along with it's timer.
class _DebounceTimer {
  Timer _timer;
  final Function action;

  _DebounceTimer(
    Duration timeout,
    this.action,
  ) {
    _timer = Timer(timeout, this.action);
  }

  void runNow() {
    cancel();
    this.action();
  }

  void cancel() {
    _timer.cancel();
  }
}
