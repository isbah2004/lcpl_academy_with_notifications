
import 'package:flutter/material.dart';

class VisibilityProvider extends ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void setVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }
}