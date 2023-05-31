import 'package:medapp/domain/data_providers/auth_provider.dart';
import 'package:medapp/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _authProvider = AuthProvider();

  Future<String?> checkAuth() async {
    final id = await _sessionDataProvider.getID();
    return id;
  }

  Future<void> login(String login, String password) async {
    final id = await _authProvider.login(login, password);

    await _sessionDataProvider.saveAccountID(id);
  }

  Future<void> logout() async {
    await _sessionDataProvider.clearID();
  }
}