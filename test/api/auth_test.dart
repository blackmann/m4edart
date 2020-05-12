import 'package:flutter_test/flutter_test.dart';
import 'package:m4edart/api/auth.dart';

import 'package:m4edart/placeholder.dart' as placeholder;
import 'package:uuid_type/uuid_type.dart';

main() {
  test('get signed in user', () async {
    final user = await Auth.instance.initialize(testing: true);

    expect(user.id, equals(Uuid(placeholder.userId)));
  });

  test('get user wallets', () async {
    final user = await Auth.instance.initialize(testing: true);

    // just succeed
    await user.getWallets();
  });
}
