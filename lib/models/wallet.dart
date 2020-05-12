import 'package:meta/meta.dart';
import 'package:uuid_type/uuid_type.dart';

class Wallet {
  final Uuid id;
  WalletInfo walletInfo;

  Wallet({@required this.id});

  Future<WalletInfo> getWalletInfo() async {
    if (walletInfo != null) {
      return walletInfo;
    }

    throw UnimplementedError();
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
}

class WalletInfo {
  final String label;
  final String currency;
  final WalletType walletType;

  WalletInfo({@required this.label, @required this.currency, this.walletType = WalletType.bascule});
}
