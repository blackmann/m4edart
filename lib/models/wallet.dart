import 'package:meta/meta.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:m4edart/api/auth.dart';
import 'package:m4edart/api/exceptions.dart';
import 'package:m4edart/constants.dart';
import 'package:m4edart/api/rest.dart' as rest;

class Wallet {
  final Uuid id;
  WalletInfo walletInfo;

  Wallet({@required this.id, this.walletInfo});

  /// Returns the details of this wallet.
  ///
  /// Throws `AuthException` if there is no user initialized for the app.
  ///
  Future<WalletInfo> getWalletInfo() async {
    if (walletInfo != null) {
      return walletInfo;
    }

    if (Auth.instance.getUser() == null) {
      throw AuthException(message: ExceptionMessages.kNoAuthUser);
    }

    return await rest.getWalletInfo(id);
  }
}

class WalletType {
  final String _type;

  const WalletType._(this._type);

  // Template
  static const bascule = WalletType._('BASCULE');

  static WalletType parse(String type) {
    return WalletType._(type);
  }

  @override
  operator ==(cmp) => (cmp is WalletType) && cmp._type == _type;

  @override
  int get hashCode => _type.hashCode;

  @override
  String toString() => _type;
}

class WalletInfo {
  final String label;
  final String currency;
  final WalletType type;

  WalletInfo(
      {@required this.label,
      @required this.currency,
      this.type = WalletType.bascule});

  static WalletInfo fromMap(Map<String, dynamic> data) {
    return WalletInfo(
        label: data['label'],
        currency: data['currency'],
        type: WalletType.parse(data['type']));
  }
}
