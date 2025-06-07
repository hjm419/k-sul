// lib/navigation_service.dart

import 'package:k_sul/liquor_model.dart'; // Liquor 모델 import

class NavigationService {
  // 앱 전체에서 접근할 수 있는 static 변수를 만듭니다.
  // 상세 페이지로 전달할 Liquor 객체를 여기에 잠시 보관합니다.
  static Liquor? selectedLiquor;
}