import 'package:meta/meta.dart';

enum TransactionStatus { pending, failed, success }

class Transaction {
  final TransactionStatus status;

  Transaction({@required this.status});
}
