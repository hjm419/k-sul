import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_model.dart';
export 'favorite_model.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  static String routeName = 'favorite';
  static String routePath = '/favorite';

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  late FavoriteModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FavoriteModel());
  }

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              // 검색 & 헤더
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: FlutterFlowTheme.of(context).primaryText),
                      onPressed: () => context.safePop(),
                    ),
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFC5C5C5)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '검색',
                                  isDense: true,
                                ),
                              ),
                            ),
                            Icon(Icons.search,
                                color:
                                FlutterFlowTheme.of(context).primaryText),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.camera_alt_outlined,
                        color: const Color(0xFFF97E1A)),
                  ],
                ),
              ),
              // 즐겨찾기 헤더
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: FlutterFlowTheme.of(context).primaryBackground,
                child: Row(
                  children: [
                    Image.asset('assets/images/star1.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('즐겨찾기',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Divider(thickness: 2),
              // 데이터 그리드
              Expanded(
                child: StreamBuilder<
                    QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('data-EN')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    return Padding(
                      // 하단 여백을 줄였습니다: vertical=4
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data();
                          final imgUrl = data['ksulImg'] as String? ?? '';
                          final name = data['ksulName'] as String? ?? '';
                          final region = data['ksulRegion'] as String? ?? '';
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 이미지 영역: 정사각형, 중앙 정렬
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: AspectRatio(
                                      aspectRatio: 1, // 정사각형
                                      child: Container(
                                        color: FlutterFlowTheme.of(context)
                                            .accent4,
                                        child: imgUrl.isNotEmpty
                                            ? Image.network(
                                          imgUrl,
                                          fit: BoxFit.cover,
                                        )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ),
                                ),
                                // 이름
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // 지역
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  child: Text(
                                    region,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // 하단 네비게이션
              Container(
                height: 85,
                decoration: BoxDecoration(
                  color:
                  FlutterFlowTheme.of(context).secondaryBackground,
                  border: Border(
                      top: BorderSide(color: const Color(0xFFBCBCBC))),
                ),
                child: Row(
                  children: [
                    _navItem(context, '메뉴',
                        'assets/images/free-icon-font-menu-burger-3917215.png',
                        Menu1Widget.routeName),
                    _navItem(context, '내 취향은?',
                        'assets/images/free-icon-alcohol-7090578.png',
                        RecommendPage11Widget.routeName),
                    _navItem(
                      context,
                      '홈',
                      'assets/images/free-icon-font-home-3917033.png',
                      MainpageWidget.routeName,
                      extra: {
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 0),
                        )
                      },
                    ),
                    _navItem(context, '리뷰',
                        'assets/images/free-icon-font-feedback-alt-13085342.png',
                        ReveiwpageWidget.routeName),
                    _navItem(context, '내정보',
                        'assets/images/free-icon-font-user-3917559.png',
                        MyinfopageWidget.routeName),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String label, String asset,
      String routeName,
      {Map<String, dynamic>? extra}) {
    return Expanded(
      child: InkWell(
        onTap: () => context.pushNamed(routeName, extra: extra),
        splashColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, width: 30, height: 30),
            const SizedBox(height: 4),
            Text(label,
                style: FlutterFlowTheme.of(context)
                    .bodyMedium
                    .override(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
