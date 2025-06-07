import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:k_sul/liquor_model.dart'; // Liquor 모델 클래스 import
import 'package:k_sul/navigation_service.dart'; // NavigationService import
import 'drink_information_page_model.dart';
export 'drink_information_page_model.dart';

class DrinkInformationPageWidget extends StatefulWidget {
  // 생성자에서 파라미터를 받지 않습니다.
  const DrinkInformationPageWidget({super.key});

  static String routeName = 'DrinkInformationPage';
  static String routePath = '/drinkInformationPage';

  @override
  State<DrinkInformationPageWidget> createState() =>
      _DrinkInformationPageWidgetState();
}

class _DrinkInformationPageWidgetState extends State<DrinkInformationPageWidget> {
  late DrinkInformationPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 페이지에서 사용할 Liquor 객체를 담을 변수
  Liquor? _liquorDetails;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DrinkInformationPageModel());

    // NavigationService의 임시 변수에서 데이터를 가져옵니다.
    _liquorDetails = NavigationService.selectedLiquor;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build 메서드에서 사용할 지역 변수로 옮겨서 null 안정성을 확보합니다.
    final liquorDetails = _liquorDetails;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          // 데이터가 없으면 "정보 없음" 메시지를, 있으면 상세 UI를 표시합니다.
          child: liquorDetails == null
              ? Center(child: Text('표시할 술의 정보가 없습니다.'))
              : _buildLiquorUI(context, liquorDetails),
        ),
      ),
    );
  }

  // 실제 UI를 그리는 부분을 별도의 위젯으로 분리하여 코드를 깔끔하게 유지합니다.
  Widget _buildLiquorUI(BuildContext context, Liquor liquor) {
    // 도수 포맷팅
    final numericAlc = liquor.originalAlcoholPercentage.replaceAll(RegExp(r'[^0-9.]'), '');
    final displayAlc = numericAlc.isNotEmpty ? '$numericAlc도' : liquor.originalAlcoholPercentage;

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Container(
                height: 154.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.85, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              shape: BoxShape.circle,
                            ),
                            // ▼▼▼ [데이터 바인딩] 술 이미지 표시 ▼▼▼
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: liquor.imageUrl.isNotEmpty
                                  ? Image.network(
                                liquor.imageUrl,
                                width: 120.0,
                                height: 120.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image_outlined),
                              )
                                  : Icon(Icons.no_photography_outlined),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              color: Color(0xFFFFFF33),
                              size: 24.0,
                            ),
                            // TODO: liquor 모델에 별점 데이터 추가 후 연결 필요
                            Text(
                              '4.5', // 예시 별점
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 187.71,
                          height: 110.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ▼▼▼ [데이터 바인딩] 술 이름 표시 ▼▼▼
                              Text(
                                liquor.name,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 24.0,
                                ),
                              ),
                              // ▼▼▼ [데이터 바인딩] 술 상세정보 표시 ▼▼▼
                              Text(
                                '${liquor.volume} | $displayAlc | ${liquor.manufacturer} | ${liquor.alcoholType}',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              // TODO: liquor 모델에 평가 인원 데이터 추가 후 연결 필요
                              Text(
                                '총 123명이 평가했습니다', // 예시
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Container(
                width: 393.0,
                height: 181.2,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('요약 리포트', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    // ▼▼▼ [데이터 바인딩] 당도/산도/바디감 표시 ▼▼▼
                    _buildFlavorIndicator(context, '당도', liquor.sugarPoint),
                    _buildFlavorIndicator(context, '산도', liquor.acidityPoint),
                    _buildFlavorIndicator(context, '바디', liquor.bodyPoint),
                  ],
                ),
              ),
            ),
            // ... 이하 '대표적인 원재료', 'Best 평가' 등 다른 UI 부분 ...
            // 이 부분들도 liquor 객체의 데이터로 채울 수 있습니다.
            _buildIngredientsSection(context, liquor.ingredients),
          ],
        ),
      ],
    );
  }

  // 맛/향/바디감 표시를 위한 헬퍼 위젯 추가
  Widget _buildFlavorIndicator(BuildContext context, String label, double value) {
    // 점수(0~5)를 퍼센트(0.0~1.0)로 변환
    final percent = (value / 5.0).clamp(0.0, 1.0);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(label, style: FlutterFlowTheme.of(context).bodyMedium),
        Container(
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          child: LinearPercentIndicator(
            percent: percent,
            lineHeight: 20.0,
            animation: true,
            progressColor: FlutterFlowTheme.of(context).primary,
            backgroundColor: FlutterFlowTheme.of(context).accent4,
            center: Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'InterTight',
                fontSize: 14.0,
              ),
            ),
            barRadius: Radius.circular(18.0),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context, List<String> ingredients) {
    // 원재료 데이터가 없거나 비어있으면 아무것도 표시하지 않음
    if (ingredients.isEmpty || (ingredients.length == 1 && ingredients.first.isEmpty)) {
      return SizedBox.shrink(); // 공간을 차지하지 않는 빈 위젯
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        width: 393.0,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '대표적인 원재료',
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.0),
            // Wrap 위젯은 자식들이 가로 공간을 넘어가면 자동으로 다음 줄로 넘겨줍니다.
            Wrap(
              spacing: 8.0, // 태그 사이의 가로 간격
              runSpacing: 4.0, // 태그 줄 사이의 세로 간격
              children: ingredients.map((ingredient) => Chip(
                label: Text(ingredient),
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                shape: StadiumBorder(side: BorderSide(color: FlutterFlowTheme.of(context).alternate)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}