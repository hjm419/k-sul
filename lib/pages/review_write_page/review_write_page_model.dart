import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'review_write_page_widget.dart' show ReviewWritePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewWritePageModel extends FlutterFlowModel<ReviewWritePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ReviewWrite widget.
  FocusNode? reviewWriteFocusNode;
  TextEditingController? reviewWriteTextController;
  String? Function(BuildContext, String?)? reviewWriteTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    reviewWriteFocusNode?.dispose();
    reviewWriteTextController?.dispose();
  }
}
