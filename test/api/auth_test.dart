import 'package:test/test.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:m4edart/api/auth.dart';
import 'package:m4edart/placeholder.dart' as placeholder;
import 'package:m4edart/models/models.dart';

main() {
  tearDown(() {
    Auth.instance.logout();
  });
  test('get signed in user', () async {
    final user = await Auth.instance.initialize(testing: true);

    expect(user.id, equals(Uuid(placeholder.userId)));
  });

  test('get user wallets, should return a list of wallets', () async {
    final user = await Auth.instance.initialize(testing: true);

    final wallets = await user.getWallets();

    expect(wallets, TypeMatcher<List>());
  });

  test('get wallet detail', () async {
    await Auth.instance.initialize(testing: true);

    final wallet = Wallet(id: Uuid('4e6a765d-f23c-4112-aed9-64739ebfdd4a'));

    final walletInfo = await wallet.getWalletInfo();

    expect(walletInfo.label, equals('YWallet'));
  });
}
