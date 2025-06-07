import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  /// 추천 페이지에서 사용하는 게이지
  double _RecommendGauge = 0.0;
  double get RecommendGauge => _RecommendGauge;
  set RecommendGauge(double value) {
    _RecommendGauge = value;
  }

  bool _PriceValue = false;
  bool get PriceValue => _PriceValue;
  set PriceValue(bool value) {
    _PriceValue = value;
  }

  /// 상관없음 버튼
  bool _NevermindButton = false;
  bool get NevermindButton => _NevermindButton;
  set NevermindButton(bool value) {
    _NevermindButton = value;
  }

  /// 오렌지색
  Color _OrangeColor = Color(4294540826);
  Color get OrangeColor => _OrangeColor;
  set OrangeColor(Color value) {
    _OrangeColor = value;
  }

  /// 흰색
  Color _WhiteColor = Color(4294967295);
  Color get WhiteColor => _WhiteColor;
  set WhiteColor(Color value) {
    _WhiteColor = value;
  }

  bool _RecommendNMTF1 = false;
  bool get RecommendNMTF1 => _RecommendNMTF1;
  set RecommendNMTF1(bool value) {
    _RecommendNMTF1 = value;
  }

  bool _RecommendNMTF2 = false;
  bool get RecommendNMTF2 => _RecommendNMTF2;
  set RecommendNMTF2(bool value) {
    _RecommendNMTF2 = value;
  }

  bool _RecommendNMTF3 = false;
  bool get RecommendNMTF3 => _RecommendNMTF3;
  set RecommendNMTF3(bool value) {
    _RecommendNMTF3 = value;
  }

  bool _RecommendNMTF4 = false;
  bool get RecommendNMTF4 => _RecommendNMTF4;
  set RecommendNMTF4(bool value) {
    _RecommendNMTF4 = value;
  }

  bool _RecommendNMTF5 = false;
  bool get RecommendNMTF5 => _RecommendNMTF5;
  set RecommendNMTF5(bool value) {
    _RecommendNMTF5 = value;
  }

  String _DrinkBody = 'Fullbody';
  String get DrinkBody => _DrinkBody;
  set DrinkBody(String value) {
    _DrinkBody = value;
  }

  double _acidityPoint = 0.0;
  double get acidityPoint => _acidityPoint;
  set acidityPoint(double value) {
    _acidityPoint = value;
  }

  double _bodyPoint = 0.0;
  double get bodyPoint => _bodyPoint;
  set bodyPoint(double value) {
    _bodyPoint = value;
  }

  double _sugarPoint = 0.0;
  double get sugarPoint => _sugarPoint;
  set sugarPoint(double value) {
    _sugarPoint = value;
  }

  String _alcoholCategory = '';
  String get alcoholCategory => _alcoholCategory;
  set alcoholCategory(String value) {
    _alcoholCategory = value;
  }

  int _alcoholPoint = 0;
  int get alcoholPoint => _alcoholPoint;
  set alcoholPoint(int value) {
    _alcoholPoint = value;
  }
}

Color? _colorFromIntValue(int? val) {
  if (val == null) {
    return null;
  }
  return Color(val);
}
