import 'package:m4edart/models/amount.dart';
import 'package:m4edart/models/wallet.dart';
import 'package:meta/meta.dart';

enum TransactionStatus { pending, failed, success }

class Transaction {
  final Wallet from;
  final Wallet to;
  final Amount amount;
  final DateTime at;
  final TransactionStatus status;

  Transaction(
      {@required this.from,
      @required this.to,
      @required this.amount,
      @required this.at,
      this.status = TransactionStatus.pending});
}
