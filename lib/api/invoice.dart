import 'package:m4edart/constants.dart';
import 'package:m4edart/api/exceptions.dart';
import 'package:m4edart/api/auth.dart';
import 'package:m4edart/models/wallet.dart';
import 'package:m4edart/models/amount.dart';
import 'package:m4edart/models/transaction.dart';
import 'rest.dart' as rest;

/// Payment invoice which can be filled sequentially. {TODO: Redocument}
///
/// To create an invoice, you can do
/// ```
/// final invoice = Invoice()
///                 ..from = fromWallet
///                 ..to = toWallet;
/// ```
///
/// Other fields can be set or changed later.
/// ```
/// invoice.amount = Amount(4.0);
/// invoice.purpose = 'Paid school fees';
/// ```
///
class Invoice {
  Wallet from;
  Wallet to;
  Amount amount;
  final Map<String, dynamic> meta = {};

  set callback(String url) => meta['callbackUrl'] = url;

  set purpose(String purposeOfTransaction) =>
      meta['purpose'] = purposeOfTransaction;

  set data(Map<String, dynamic> d) => meta['data'] = d;

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
    validate();

    final form = await _buildForm();

    // if same wallets
    if (from == to) {
      throw InvalidInvoiceException(
          field: 'to',
          message:
              'The receiving wallet should not be the same as the sending wallet.');
    }

    if (Auth.instance.getUser() == null) {
      throw AuthException(message: ExceptionMessages.kNoAuthUser);
    }

    final transaction = await rest.sendInvoice(form);

    return transaction;
  }

  /// Verifies all required fields are supplied. Call this on UI to validate
  /// forms.
  void validate() {
    if (from == null) {
      throw InvalidInvoiceException(
          field: 'from', message: '[from] wallet has not been set');
    }

    if (to == null) {
      throw InvalidInvoiceException(
          field: 'to', message: '[to] wallet has not been set');
    }

    if (amount == null) {
      throw InvalidInvoiceException(
          field: 'amount', message: '[amount] has not been set');
    }
  }

  /// Prepare the transaction form
  Future<Map<String, dynamic>> _buildForm() async {
    final flow = {
      'from': await _getWalletMap(from),
      'to': await _getWalletMap(to),
      'amount': amount.toMap(),
      'at': DateTime.now().millisecondsSinceEpoch ~/ 1000
    };

    final form = {'flow': flow, 'txType': 'CASH_IN'};

    return form;
  }

  // Temporary. Wallets will be promoted to type+id
  Future<Map<String, dynamic>> _getWalletMap(Wallet wallet) async {
    final info = await wallet.getWalletInfo();

    return {
      'id': wallet.id.toString(),
      'wallet': {
        'label': info.label,
        'currency': info.currency,
        'type': info.type.toString()
      }
    };
  }
}
