/// Abstraction for current time (testable Dependency Inversion).
abstract class IClock {
  DateTime now();
}

class SystemClock implements IClock {
  @override
  DateTime now() => DateTime.now();
}
