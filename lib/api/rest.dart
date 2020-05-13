import 'dart:convert';

import 'package:m4edart/models/models.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:m4edart/requests.dart' show requests;

Future<Transaction> sendInvoice(Map<String, dynamic> form) async {
  final id = RandomBasedUuidGenerator().generate();

  final response =
      await requests.put('/transactions/$id', data: jsonEncode(form));

  if (response.statusCode == 201) {
    final flow = response.data['flow'];

    final fromWallet = Wallet(id: Uuid(flow['from']));

    final toWallet = Wallet(id: Uuid(flow['to']));

    final amount = Amount(flow['amount']['value'], flow['amount']['unit']);

    final at = DateTime.fromMillisecondsSinceEpoch(flow['at'] * 1000);

    return Transaction(from: fromWallet, to: toWallet, amount: amount, at: at);
  }

  throw Exception('Failed to make transaction');
}

/// Returns list of wallets for user with id [userId]
Future<List<Wallet>> getWallets(Uuid userId) async {
  final response =
      await requests.get('/wallets/$userId/access?access=PAY_TO&access=SEE');

  if (response.statusCode == 200) {
    return (response.data['wallets'] as List).map<Wallet>((walletItem) {
      final walletInfo = WalletInfo.fromMap(walletItem['wallet']);

      return Wallet(id: Uuid(walletItem['id']), walletInfo: walletInfo);
    }).toList();
  }

  throw Exception('Failed to load wallets');
}

/// Get wallet details
Future<WalletInfo> getWalletInfo(Uuid walletId) async {
  final response = await requests.get('/wallets/$walletId');

  if (response.statusCode == 200) {
    return WalletInfo.fromMap(response.data['wallet']);
  }

  throw Exception('Failed to load wallet details');
}
