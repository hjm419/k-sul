// k_sul/lib/pages/searchpage/searchpage_widget.dart
import 'package:k_sul/backend/schema/index.dart';
import 'package:k_sul/flutter_flow/flutter_flow_theme.dart';
import 'package:k_sul/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '/pages/searchpage/searchpage_model.dart';

class SearchpageWidget extends StatefulWidget {
  static const String routeName = 'Searchpage';
  static const String routePath = '/searchpage';

  const SearchpageWidget({super.key});

  @override
  State<SearchpageWidget> createState() => _SearchpageWidgetState();
}

class _SearchpageWidgetState extends State<SearchpageWidget>
    with TickerProviderStateMixin {
  late SearchpageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _tabs = ['전체', '탁주', '약주', '청주', '증류주', '과실주'];
  String _selectedKsulType = '전체';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchpageModel());

    _model.textController ??= TextEditingController();

    _model.tabBarController = TabController(
      length: _tabs.length,
      vsync: this,
    );
    // 탭 변경 시 _selectedKsulType 업데이트 및 화면 갱신
    _model.tabBarController!.addListener(() {
      // indexIsChanging 대신 현재 인덱스를 사용하거나, 애니메이션 종료 후 인덱스 사용
      if (!_model.tabBarController!.indexIsChanging) {
        if (_selectedKsulType != _tabs[_model.tabBarController!.index]) {
          setState(() {
            _selectedKsulType = _tabs[_model.tabBarController!.index];
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _model.dispose(); // SearchpageModel에서 textController와 tabBarController를 dispose 하도록 수정 필요
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            '전통주 검색',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                child: TextFormField(
                  controller: _model.textController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: '전통주 이름 검색...',
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                    suffixIcon: _model.textController!.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _model.textController?.clear();
                        setState(() {});
                      },
                    )
                        : null,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              TabBar(
                controller: _model.tabBarController,
                isScrollable: true,
                labelColor: FlutterFlowTheme.of(context).primaryText,
                unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                indicatorColor: FlutterFlowTheme.of(context).primary,
                tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
              ),
              Expanded(
                child: StreamBuilder<List<KsulDataEnRecord>>(
                  stream: queryKsulDataEnCollection(
                    queryBuilder: (query) {
                      var newQuery = query;

                      // 1. 탭 필터링 적용
                      if (_selectedKsulType != '전체') {
                        newQuery = newQuery.where('ksulType', isEqualTo: _selectedKsulType);
                      }

                      // 2. 검색어 처리 및 정렬
                      final searchTerm = _model.textController!.text.trim();
                      if (searchTerm.isNotEmpty) {
                        // 검색어가 있으면: ksulName으로 정렬하고 해당 이름으로 시작하는 데이터 검색
                        newQuery = newQuery.orderBy('ksulName')
                            .startAt([searchTerm])
                            .endAt([searchTerm + '\uf8ff']);
                      } else {
                        // 검색어가 없으면: created_at (최신순)으로 정렬
                        newQuery = newQuery.orderBy('created_at', descending: true);
                      }
                      // print('Firestore Query: ${newQuery.parameters}'); // 디버깅용: 실제 실행되는 쿼리 파라미터 확인
                      return newQuery;
                    },
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary,
                      ));
                    }
                    if (snapshot.hasError) {
                      print('StreamBuilder 오류: ${snapshot.error}');
                      print('스택 트레이스: ${snapshot.stackTrace}');
                      return Center(child: Text('데이터 로딩 중 오류가 발생했습니다.\n오류: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('해당 조건의 전통주가 없습니다.'));
                    }

                    final ksulList = snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: ksulList.length,
                      itemBuilder: (context, index) {
                        final ksulItem = ksulList[index];
                        return Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (ksulItem.ksulImg != null && ksulItem.ksulImg!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      ksulItem.ksulImg!,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: FlutterFlowTheme.of(context).alternate,
                                            child: Icon(Icons.broken_image, color: FlutterFlowTheme.of(context).secondaryText, size: 40),
                                          ),
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          width: double.infinity,
                                          height: 180,
                                          color: FlutterFlowTheme.of(context).alternate,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                              color: FlutterFlowTheme.of(context).primary,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 10),
                                Text(
                                  ksulItem.ksulName ?? '이름 없음',
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '종류: ${ksulItem.ksulType ?? 'N/A'}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    Text(
                                      '도수: ${ksulItem.ksulDgr ?? 'N/A'}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '지역: ${ksulItem.ksulRegion ?? 'N/A'}',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  ksulItem.ksulDetail ?? '설명 없음',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}