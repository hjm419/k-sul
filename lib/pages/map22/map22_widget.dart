import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// 필요한 Firestore 및 데이터 모델 import
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/korean_brewery_data_record.dart';

import 'map22_model.dart';
export 'map22_model.dart';

class Map22Widget extends StatefulWidget {
  const Map22Widget({
    super.key,
    this.asd,
  });

  final FFUploadedFile? asd;

  static String routeName = 'map22';
  static String routePath = '/map22';

  @override
  State<Map22Widget> createState() => _Map22WidgetState();
}

class _Map22WidgetState extends State<Map22Widget>
    with TickerProviderStateMixin {
  late Map22Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Map22Model());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.tabBarController1 = TabController(
      vsync: this,
      length: 7,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.tabBarController2 = TabController(
      vsync: this,
      length: 7,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Firestore에서 양조장 데이터 스트림을 가져오는 함수
  Stream<List<KoreanBreweryDataRecord>> getBreweryStream({String? regionFilter}) {
    Query query = FirebaseFirestore.instance.collection('korean_brewery_data');

    // 지역 필터링이 필요한 경우 쿼리 조건 추가
    if (regionFilter != null && regionFilter.isNotEmpty) {
      query = query
          .where('address', isGreaterThanOrEqualTo: regionFilter)
          .where('address', isLessThan: regionFilter + '\uf8ff');
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => KoreanBreweryDataRecord.fromSnapshot(doc))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (widget.asd != null && (widget.asd?.bytes?.isNotEmpty ?? false)) {
                      return buildMainContent(context, _model.tabBarController1, _model.textController1, _model.textFieldFocusNode1);
                    } else {
                      return buildMainContent(context, _model.tabBarController2, _model.textController2, _model.textFieldFocusNode2);
                    }
                  },
                ),
              ),
              buildBottomNavBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMainContent(BuildContext context, TabController? tabController, TextEditingController? textController, FocusNode? focusNode) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        buildSearchBar(context, textController, focusNode),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment(0.0, 0),
                child: FlutterFlowButtonTabBar(
                  useToggleButtonStyle: true,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(),
                  labelColor: FlutterFlowTheme.of(context).primaryText,
                  unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                  backgroundColor: FlutterFlowTheme.of(context).accent1,
                  unselectedBackgroundColor: FlutterFlowTheme.of(context).alternate,
                  borderColor: FlutterFlowTheme.of(context).primaryText,
                  unselectedBorderColor: FlutterFlowTheme.of(context).alternate,
                  borderWidth: 1.0,
                  borderRadius: 8.0,
                  elevation: 0.0,
                  buttonMargin: EdgeInsets.symmetric(horizontal: 8.0),
                  tabs: [
                    Tab(text: '전체'),
                    Tab(text: '수도권'),
                    Tab(text: '강원'),
                    Tab(text: '충청'),
                    Tab(text: '경상'),
                    Tab(text: '전라'),
                    Tab(text: '제주'),
                  ],
                  controller: tabController,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // 각 탭에 맞는 데이터 스트림을 전달
                    buildBreweryGridView(getBreweryStream()),
                    buildBreweryGridView(getBreweryStream(regionFilter: '수도권')),
                    buildBreweryGridView(getBreweryStream(regionFilter: '강원')),
                    buildBreweryGridView(getBreweryStream(regionFilter: '충청')),
                    buildBreweryGridView(getBreweryStream(regionFilter: '경상')),
                    buildBreweryGridView(getBreweryStream(regionFilter: '전라')),
                    buildBreweryGridView(getBreweryStream(regionFilter: '제주')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBreweryGridView(Stream<List<KoreanBreweryDataRecord>> stream) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<KoreanBreweryDataRecord>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('해당 지역의 양조장 정보가 없습니다.'));
          }

          List<KoreanBreweryDataRecord> gridViewBreweryItems = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.8,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: gridViewBreweryItems.length,
            itemBuilder: (context, gridViewIndex) {
              final brewery = gridViewBreweryItems[gridViewIndex];
              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                      child: Image.network(
                        // ==================== MODIFICATION START ====================
                        // breweryImg 필드에 값이 있으면 그 값을 사용하고, 없으면 기존 플레이스홀더를 사용합니다.
                        (brewery.hasBreweryImg() && brewery.breweryImg.isNotEmpty)
                            ? brewery.breweryImg
                            : (brewery.website?.isNotEmpty == true ? 'https://via.placeholder.com/200x150.png?text=${brewery.name}' : 'https://via.placeholder.com/200x150.png?text=No+Image'),
                        // ===================== MODIFICATION END =====================
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/achol.jpg',  width: double.infinity, height: 120, fit: BoxFit.cover), // 에러 시 로컬 이미지
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brewery.name,
                            style: FlutterFlowTheme.of(context).bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            brewery.address,
                            style: FlutterFlowTheme.of(context).bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.visibility_outlined, size: 16, color: FlutterFlowTheme.of(context).secondaryText),
                              SizedBox(width: 4),
                              Text(
                                '${brewery.views}',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 상단 검색 바 (기존 코드와 동일)
  Widget buildSearchBar(BuildContext context, TextEditingController? textController, FocusNode? focusNode) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 42.6,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [BoxShadow(blurRadius: 4.0, color: Color(0x33000000), offset: Offset(0.0, 2.0))],
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: Color(0xFFC5C5C5)),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: InkWell(
                onTap: () async => context.safePop(),
                child: Icon(Icons.arrow_back, color: FlutterFlowTheme.of(context).primaryText, size: 24.0),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: '양조장 검색...',
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    border: InputBorder.none,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.search, color: FlutterFlowTheme.of(context).primaryText, size: 24.0),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 네비게이션 바 (기존 코드와 동일)
  Widget buildBottomNavBar(BuildContext context) {
    return Container(
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
              onTap: () async => context.pushNamed(Menu1Widget.routeName),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu, size: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text('메뉴', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async => context.pushNamed(RecommendPage11Widget.routeName),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/free-icon-alcohol-7090578.png', width: 30, height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text('내 취향은?', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async => context.pushNamed(
                MainpageWidget.routeName,
                extra: <String, dynamic>{
                  kTransitionInfoKey: TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                    duration: Duration(milliseconds: 0),
                  ),
                },
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/free-icon-font-home-3917033.png', width: 30, height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text('홈', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async => context.pushNamed(ReveiwpageWidget.routeName),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/free-icon-font-feedback-alt-13085342.png', width: 30, height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text('리뷰', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async => context.pushNamed(MyinfopageWidget.routeName),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/free-icon-font-user-3917559.png', width: 30, height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text('내정보', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}