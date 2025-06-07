// k_sul/lib/pages/searchpage/searchpage_model.dart
import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import '/pages/searchpage/searchpage_widget.dart' show SearchpageWidget;

class SearchpageModel extends FlutterFlowModel<SearchpageWidget> {
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  TabController? tabBarController;

  @override
  void initState(BuildContext context) {
  }

  @override
  void dispose() {
    textController?.dispose(); // textController 해제 추가
    tabBarController?.dispose(); // tabBarController 해제 추가
  }
}