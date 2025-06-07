import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'recommend_page_result_model.dart';
export 'recommend_page_result_model.dart';
import 'package:k_sul/liquor_model.dart';
import 'package:k_sul/app_state.dart';
import 'package:k_sul/liquor_service.dart';
import 'package:k_sul/navigation_service.dart';

class RecommendPageResultWidget extends StatefulWidget {
  const RecommendPageResultWidget({super.key});

  static String routeName = 'RecommendPageResult';
  static String routePath = '/recommendPageResult';

  @override
  State<RecommendPageResultWidget> createState() =>
      _RecommendPageResultWidgetState();
}

class _RecommendPageResultWidgetState extends State<RecommendPageResultWidget> {
  late RecommendPageResultModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Liquor>>? _recommendedLiquorsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecommendPageResultModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRecommendedLiquors();
    });
  }

  void _fetchRecommendedLiquors() {
    final appState = Provider.of<FFAppState>(context, listen: false);

    final prefs = UserPreferences(
      acidityPoint: appState.acidityPoint,
      sugarPoint: appState.sugarPoint,
      bodyPoint: appState.bodyPoint,
      alcoholPoint: appState.alcoholPoint,
      alcoholType: appState.alcoholCategory,
    );

    setState(() {
      _recommendedLiquorsFuture = findRecommendedLiquors(prefs);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            '내 취향 술찾기 결과',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<Liquor>>(
            future: _recommendedLiquorsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('오류: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('아쉽지만, 조건에 맞는 술을 찾지 못했어요. 😥'));
              }

              final liquor = snapshot.data!.first;
              final numericAlc = liquor.originalAlcoholPercentage.replaceAll(RegExp(r'[^0-9.]'), '');
              final displayAlc = numericAlc.isNotEmpty ? '$numericAlc도' : liquor.originalAlcoholPercentage;

              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 24.0),
                      Container(
                        width: 200.0,
                        height: 244.2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).tertiary,
                            width: 2.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: liquor.imageUrl.isNotEmpty
                              ? Image.network(
                            liquor.imageUrl,
                            width: 400.0,
                            height: 236.6,
                            fit: BoxFit.scaleDown,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image_outlined,
                                size: 50,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              );
                            },
                          )
                              : Icon(
                            Icons.no_photography_outlined,
                            size: 50,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              liquor.name,
                              style: FlutterFlowTheme.of(context).headlineSmall,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '주종: ${liquor.alcoholType} | 용량: ${liquor.volume}\n도수: $displayAlc | 제조사: ${liquor.manufacturer}',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRatingWidget(context, '맛', '5.0'),
                          _buildRatingWidget(context, '향', '5.0'),
                          _buildRatingWidget(context, '가성비', '5.0'),
                        ].divide(SizedBox(width: 20.0)),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        '당신에게 가장 추천하는 우리술입니다!',
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                      SizedBox(height: 16.0),
                      FFButtonWidget(
                        onPressed: () {
                          print('--- [전달 페이지] 데이터 전달 시도 ---');
                          print('저장하려는 술 객체: ${liquor}');
                          print('저장하려는 술 이름: ${liquor.name}');

                          // 임시 변수에 현재 liquor 객체를 저장합니다.
                          NavigationService.selectedLiquor = liquor;

                          print('NavigationService에 저장된 객체: ${NavigationService.selectedLiquor}');

                          context.pushNamed(DrinkInformationPageWidget.routeName);
                        },
                        text: '자세한 정보',
                        options: FFButtonOptions(
                          width: 130,
                          height: 40.0,
                          color: FlutterFlowTheme.of(context).tertiary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      // ▼▼▼ 중요: 하단 네비게이션 바에 가려지지 않도록 안전 여백 추가 ▼▼▼
                      SizedBox(height: 85.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // ▼▼▼ 2. body에 있던 네비게이션 바를 Scaffold의 bottomNavigationBar 속성으로 이동 ▼▼▼
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 85.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            border: Border.all(
              color: Color(0xFFBCBCBC),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(Menu1Widget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/free-icon-font-menu-burger-3917215.png',
                            width: double.infinity,
                            height: 32.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '메뉴',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(RecommendPage11Widget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            'assets/images/free-icon-alcohol-7090578.png',
                            width: 0.0,
                            height: 0.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '내 취향은?',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      MainpageWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            'assets/images/free-icon-font-home-3917033.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '홈',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(ReveiwpageWidget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            'assets/images/free-icon-font-feedback-alt-13085342.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '리뷰',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(MyinfopageWidget.routeName);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            'assets/images/free-icon-font-user-3917559.png',
                            width: 0.0,
                            height: 44.4,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '내정보',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildRatingWidget(BuildContext context, String label, String score) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
        SizedBox(width: 4.0),
        Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 20.0),
        SizedBox(width: 2.0),
        Text(
          score,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyLarge,
        ),
      ],
    );
  }
}