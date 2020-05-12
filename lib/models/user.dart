import 'package:uuid_type/uuid_type.dart';
import 'package:m4edart/api/rest.dart' as rest;
import 'package:meta/meta.dart';
import 'wallet.dart';

class User {
  final Uuid id;

  User({@required this.id});

  /// Returns the user details. Name, phone, address, photo, etc.
  Future<UserInfo> getUserInfo() async {
    throw UnimplementedError();
  }

  /// Returns wallets for this user
  Future<List<Wallet>> getWallets() async {
    return rest.getWallets(id);
  }
}

class UserInfo {
  final String firstName;
  final String lastName;
  final String phone;

  UserInfo({@required this.firstName, @required this.lastName, @required this.phone});
}
