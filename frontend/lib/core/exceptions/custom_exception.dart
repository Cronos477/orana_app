class ReqExeption implements Exception {
  final String message;
  final int? statusCode;

  ReqExeption({
    required this.message,
    this.statusCode
  });

  @override
  String toString() => 'RequestException: $message (Status: $statusCode)';
}
