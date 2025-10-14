import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void cleaError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> execute(Future<void> Function() action) async {
    setLoading(true);
    cleaError();

    try {
      await action();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
