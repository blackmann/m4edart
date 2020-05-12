import 'package:meta/meta.dart';

class AuthException implements Exception {
  final String message;

  AuthException({@required this.message});

  @override
  String toString() {
    return '[AuthException] $message';
  }
}

class TransactionFailedException implements Exception {
  final String code;
  final String message;

  TransactionFailedException({@required this.code, @required this.message});
}

class InvalidInvoiceException implements Exception {
  final String field;
  final String message;

  InvalidInvoiceException({@required this.field, @required this.message});

  @override
  String toString() {
    return '[InvalidInvoiceException] {field: $field, error: $message}';
  }
}
