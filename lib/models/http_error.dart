class HttpError implements Exception {
  final String message;

  HttpError(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpError
  }
}
