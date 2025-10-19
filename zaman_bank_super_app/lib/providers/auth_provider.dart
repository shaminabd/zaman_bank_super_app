import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String iin, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final loginRequest = UserLoginRequest(iin: iin, password: password);
      final loginResponse = await AuthService.login(loginRequest);
      
      _user = User(
        id: loginResponse.userId,
        firstName: loginResponse.firstName,
        lastName: loginResponse.lastName,
        iin: loginResponse.iin,
        phoneNumber: loginResponse.phoneNumber,
        balance: loginResponse.balance,
        token: loginResponse.token,
      );

      await AuthService.saveUserData(_user!);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String iin,
    required String phoneNumber,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final registrationRequest = UserRegistrationRequest(
        firstName: firstName,
        lastName: lastName,
        iin: iin,
        phoneNumber: phoneNumber,
        password: password,
      );
      
      final user = await AuthService.register(registrationRequest);
      _user = user;
      
      await AuthService.saveUserData(_user!);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    
    try {
      final storedUser = await AuthService.getStoredUser();
      if (storedUser != null) {
        _user = storedUser;
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
