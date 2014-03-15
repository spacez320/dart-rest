part of rest;

class Logger {
  void log(String message) {
    print('${new DateTime.now()}: $message');
  }
}
