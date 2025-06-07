// lib/liquor_model.dart (최종 수정본)

class Liquor {
  final String name;                 // 제품명 (CSV 인덱스 2)
  final double sugarPoint;           // 단맛 (CSV 인덱스 3)
  final double acidityPoint;         // 신맛 (CSV 인덱스 4)
  final double refreshmentPoint;     // 청량감 (CSV 인덱스 5)
  final double bodyPoint;            // 바디감 (CSV 인덱스 6)
  final int alcoholPoint;            // 도수 카테고리
  final String alcoholType;          // 주종 (CSV 인덱스 9)
  final String originalAlcoholPercentage; // 원본 도수% (CSV 인덱스 7)
  final String volume;               // 용량 (CSV 인덱스 11)
  final String manufacturer;         // 제조사 (CSV 인덱스 13)
  final String imageUrl;             // 이미지 URL (CSV 인덱스 16)
  final List<String> ingredients;

  Liquor({
    required this.name,
    required this.sugarPoint,
    required this.acidityPoint,
    required this.refreshmentPoint,
    required this.bodyPoint,
    required this.alcoholPoint,
    required this.alcoholType,
    required this.originalAlcoholPercentage,
    required this.volume,
    required this.manufacturer,
    required this.imageUrl,
    required this.ingredients,
  });

  static int _convertAlcoholToCategory(String alcoholPercentageString) {
    if (alcoholPercentageString.isEmpty) return -1;
    final numericPart = alcoholPercentageString.replaceAll(RegExp(r'[^0-9.]'), '');
    if (numericPart.isEmpty) return -1;
    double? percentage = double.tryParse(numericPart);
    if (percentage == null) return -1;
    if (percentage < 10.0) return 0;
    if (percentage < 20.0) return 10;
    if (percentage < 30.0) return 20;
    if (percentage < 40.0) return 30;
    return 40;
  }

  factory Liquor.fromCsvRow(List<dynamic> row) {

    String ingredientsString = row.length > 14 ? row[14]?.toString() ?? '' : '';

    if (ingredientsString.startsWith('"') && ingredientsString.endsWith('"')) {
      ingredientsString = ingredientsString.substring(1, ingredientsString.length - 1);
    }

    final ingredientsList = ingredientsString
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Liquor(
      name: row[2]?.toString() ?? '이름 없음',
      sugarPoint: double.tryParse(row[3]?.toString() ?? '') ?? 0.0,
      acidityPoint: double.tryParse(row[4]?.toString() ?? '') ?? 0.0,
      refreshmentPoint: double.tryParse(row[5]?.toString() ?? '') ?? 0.0,
      bodyPoint: double.tryParse(row[6]?.toString() ?? '') ?? 0.0,
      originalAlcoholPercentage: row[7]?.toString() ?? '',
      alcoholPoint: _convertAlcoholToCategory(row[7]?.toString() ?? ''),
      alcoholType: row[9]?.toString() ?? '주종 정보 없음',
      volume: row[11]?.toString() ?? '용량 정보 없음',
      manufacturer: row[13]?.toString() ?? '제조사 정보 없음',
      imageUrl: row[15]?.toString() ?? '',
      ingredients: ingredientsList,
    );
  }

  // 객체의 주요 정보를 문자열로 반환 (디버깅 시 유용)
  @override
  String toString() {
    return 'Liquor(name: $name, type: $alcoholType, volume: $volume, manufacturer: $manufacturer, sugar: $sugarPoint, acidity: $acidityPoint, refreshment: $refreshmentPoint, body: $bodyPoint, alcoholCat: $alcoholPoint, origAlc: $originalAlcoholPercentage)';
  }
}