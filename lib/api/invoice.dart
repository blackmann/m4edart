import 'package:meta/meta.dart';
import 'package:m4edart/api/exceptions.dart';
import 'package:m4edart/api/auth.dart';
import 'package:m4edart/models/models.dart';
import 'rest.dart' as rest;

class Invoice {
  final Wallet from;
  final Wallet to;
  final Amount amount;
  final Map<String, dynamic> meta = {};

  set callback(String url) => meta['callbackUrl'] = url;

  set purpose(String purposeOfTransaction) => meta['purpose'] = purposeOfTransaction;

  set data(Map<String, dynamic> d) => meta['data'] = d;

  Invoice({@required this.from, @required this.to, @required this.amount});

  /// Performs a payment process by sending invoice to m4e. Returns a `pending`
  /// transaction if m4e accepts the invoice and begins the transaction.
  ///
  /// Throws `AuthException` if there is no user initialized for the app.
  ///
  /// Throws `TransactionFailedException` if m4e responds with an error which may
  /// be an unauthorized request (user does not have permission to pay into
  /// the receiving wallet), wallet not found, etc.
  ///
  /// Throws `InvalidInvoiceException` when the invoice is incomplete, or has the
  /// same wallet specified [for] from and [to]
  Future<Transaction> send() async {
    final form = _buildForm();

    for (String k in form.keys) {
      if (form[k] == null) {
        throw InvalidInvoiceException(
            field: k, message: 'Invoice is incomplete. [$k] was not set.');
      }
    }

    // if same wallets
    if (from == to) {
      throw InvalidInvoiceException(
          field: 'to',
          message: 'The receiving wallet should not be the same as the sending wallet.');
    }

    if (Auth.instance.getUser() == null) {
      throw AuthException(message: 'Auth was not initialized.');
    }

    final transaction = await rest.sendInvoice(form);

    return transaction;
  }

  Map<String, dynamic> _buildForm() {
    final form = {
      'from': from,
      'to': to,
      'amount': amount.toJson(),
    };

    return form;
  }
}

class Amount {
  final double value;
  final String currency;

  Amount({@required this.value, this.currency = 'GHS'})
      : assert(currency != null),
        assert(value != null && value > 0);

  Map<String, dynamic> toJson() {
    return {'value': value, 'currency': currency};
  }
}
