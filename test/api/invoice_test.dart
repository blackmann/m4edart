import 'package:m4edart/api/auth.dart';
import 'package:m4edart/api/invoice.dart';
import 'package:m4edart/api/exceptions.dart';
import 'package:m4edart/models/models.dart';
import 'package:test/test.dart';
import 'package:uuid_type/uuid_type.dart';

main() {
  tearDown(() async {
    await Auth.instance.logout();
  });

  test('make payment', () async {
    final user = await Auth.instance.initialize(testing: true);

    final wallets = await user.getWallets();

    final fromWallet = Wallet(id: Uuid('00000000-0000-0000-0000-000000000001'));
    final toWallet = wallets[0];

    final invoice = Invoice(from: fromWallet, to: toWallet, amount: Amount(value: 3));

    final transaction = await invoice.send();

    expect(transaction.status, equals(TransactionStatus.pending));
  });

  test('make payment without initializing auth, expect AuthException', () async {
    final fromWallet = Wallet(id: Uuid('00000000-0000-0000-0000-000000000001'));
    final toWallet = Wallet(id: Uuid('00000000-0000-0000-0000-000000000002'));

    final invoice = Invoice(from: fromWallet, to: toWallet, amount: Amount(value: 3));

    expect(invoice.send(), throwsA(TypeMatcher<AuthException>()));
  });
}
