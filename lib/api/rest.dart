import 'package:m4edart/models/models.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:m4edart/requests.dart' show requests;

Future<Transaction> sendInvoice(Map<String, dynamic> form) async {
  throw UnimplementedError();
}

Future<List<Wallet>> getWallets(Uuid userId) async {
  final response = await requests.get('/wallets/$userId/access?access=PAY_TO&access=SEE');

  if (response.statusCode == 200) {
    return (response.data['wallets'] as List).map<Wallet>((walletItem) {
      return Wallet(id: Uuid(walletItem['id']));
    }).toList();
  }

  throw Exception('Failed to load wallets');
}
