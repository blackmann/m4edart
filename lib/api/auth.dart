import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:m4edart/models/models.dart';

import '../requests.dart' show requests;
import '../placeholder.dart' as placeholder;

class AuthCredentials {
  final Uuid userId;
  final String bearerToken;

  AuthCredentials({@required this.userId, @required this.bearerToken});
}

class Auth {
  User _user; // initialized user

  static final Auth instance = Auth._();

  Auth._();

  User getUser() => _user;

  /// This is called to bind a user to the m4e sdk. It returns a logged in user
  /// if there is one and sets up the requests configuration.
  ///
  /// If no user has been logged in, an `AuthException` will be thrown
  ///
  /// Setting [testing] to true, uses the test API. Use this if app is in development.
  ///
  Future<User> initialize({bool testing = false}) async {
    final authCredentials = await getSavedCredentials();

    requests.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        // TODO: provide accurate urls
        options.baseUrl = testing
            ? 'https://bascule-staging.herokuapp.com'
            : 'https://bascule-live.herokuapp.com';

        options.headers = {
          'Authorization': 'Bearer ${authCredentials.bearerToken}',
          'Content-Type': 'application/json'
        };

        return options;
      }),
    );

    _user = User(id: authCredentials.userId);

    return _user;
  }

  /// Returns a locally saved user crendential
  Future<AuthCredentials> getSavedCredentials() async {
    // TODO: use storage implementation
    return AuthCredentials(
      userId: Uuid(placeholder.userId),
      bearerToken: placeholder.token,
    );
  }

  /// Cleans up the saved user
  Future<void> logout() async {
    // TODO: properly implement
    _user = null;
  }
}
