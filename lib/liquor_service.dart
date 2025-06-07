// lib/liquor_service.dart

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:k_sul/liquor_model.dart'; // 중복되지 않도록 하나만 사용

List<Liquor> _allLiquors = [];
bool _isDataLoaded = false;

// CSV 데이터를 읽고 파싱하는 함수
Future<List<Liquor>> loadAndParseLiquorData() async {
  if (_isDataLoaded && _allLiquors.isNotEmpty) {
    return _allLiquors;
  }

  print("Loading liquor data from CSV...");
  try {
    final rawCsvData = await rootBundle.loadString('assets/traditional_liquor_df_final.csv');
    final converter = const CsvToListConverter(shouldParseNumbers: false);
    List<List<dynamic>> listDataWithHeader = converter.convert(rawCsvData);

    final bool csvHasHeader = true;
    List<List<dynamic>> listData;
    if (csvHasHeader && listDataWithHeader.isNotEmpty) {
      listData = listDataWithHeader.sublist(1);
    } else {
      listData = listDataWithHeader;
    }


    List<Liquor> liquors = [];
    for (var row in listData) {
      try {
        if (row.length > 15) { // O열(원재료명)까지 데이터가 있는지 확인
          liquors.add(Liquor.fromCsvRow(row));
        } else {
          print('Skipping row due to insufficient columns: $row');
        }
      } catch (e, s) {
        print('Error parsing CSV row: $row, Error: $e, Stacktrace: $s');
      }
    }
    _allLiquors = liquors;
    _isDataLoaded = true;
    print('${_allLiquors.length}개의 술 데이터 로드 완료.');
    return _allLiquors;
  } catch (e, s) {
    print('CSV 파일 로드 또는 파싱 중 오류 발생: $e, Stacktrace: $s');
    _isDataLoaded = false;
    return [];
  }
}

// 사용자 취향 정보를 담는 클래스
class UserPreferences {
  final double? acidityPoint;
  final double? sugarPoint;
  final double? bodyPoint;
  final int? alcoholPoint;
  final String? alcoholType;

  UserPreferences({
    this.acidityPoint,
    this.sugarPoint,
    this.bodyPoint,
    this.alcoholPoint,
    this.alcoholType,
  });
}

// 사용자 취향에 맞는 술을 찾아주는 메인 함수
Future<List<Liquor>> findRecommendedLiquors(UserPreferences preferences) async {
  // 데이터가 로드되지 않았다면 로드
  if (!_isDataLoaded || _allLiquors.isEmpty) {
    await loadAndParseLiquorData();
  }

  if (_allLiquors.isEmpty) {
    return [];
  }

  // 주종 영문 -> 한글 변환
  String? koreanAlcoholType;
  if (preferences.alcoholType != null && preferences.alcoholType != 'Any') {
    switch (preferences.alcoholType) {
      case 'TakJu':
        koreanAlcoholType = '탁주';
        break;
      case 'YakCheongJu':
        koreanAlcoholType = '약주/청주';
        break;
      case 'distilledAlcohol':
        koreanAlcoholType = '증류주';
        break;
      case 'fruitWine':
        koreanAlcoholType = '과실주';
        break;
      default:
        koreanAlcoholType = null;
    }
  }

  print(
      "Filtering ${_allLiquors.length} liquors with preferences: Acidity=${preferences.acidityPoint}, Sugar=${preferences.sugarPoint}, Body=${preferences.bodyPoint}, Alcohol=${preferences.alcoholPoint}, Type=${koreanAlcoholType ?? 'Any'}");

  return _allLiquors.where((liquor) {
    // 1. 주종 필터링 ('상관없음'이 아닐 경우)
    if (koreanAlcoholType != null) {
      if (liquor.alcoholType.trim() != koreanAlcoholType) {
        return false;
      }
    }

    // ▼▼▼ [수정된 부분] 도수 필터링 로직 ▼▼▼
    // 사용자가 선택한 도수 범위에 해당하는지 검사합니다.
    if (preferences.alcoholPoint != null) {
      final int selectedPoint = preferences.alcoholPoint!;
      // CSV에서 읽어온 도수 값 (정보가 없으면 -1)
      final double liquorAbv = liquor.alcoholPoint.toDouble();

      if (liquorAbv == -1) return false; // 도수 정보가 없는 술은 제외

      // '40도 이상'을 선택한 경우
      if (selectedPoint == 40) {
        if (liquorAbv < 40) return false;
      }
      // 그 외의 범위(0-9, 10-19, 20-29, 30-39)를 선택한 경우
      else {
        if (liquorAbv < selectedPoint || liquorAbv >= selectedPoint + 10) {
          return false;
        }
      }
    }
    // ▲▲▲ [수정 완료] ▲▲▲

    // 3. 맛/향/바디감 필터링 (0.5의 오차 허용)
    final double tolerance = 0.5;
    if (preferences.acidityPoint != null) {
      if ((liquor.acidityPoint - preferences.acidityPoint!).abs() > tolerance) {
        return false;
      }
    }
    if (preferences.sugarPoint != null) {
      if ((liquor.sugarPoint - preferences.sugarPoint!).abs() > tolerance) {
        return false;
      }
    }
    if (preferences.bodyPoint != null) {
      if ((liquor.bodyPoint - preferences.bodyPoint!).abs() > tolerance) {
        return false;
      }
    }

    // 모든 필터를 통과한 경우 true 반환
    return true;
  }).toList();
}