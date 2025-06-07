import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'review_write_page_model.dart';
export 'review_write_page_model.dart';

class ReviewWritePageWidget extends StatefulWidget {
  const ReviewWritePageWidget({super.key});

  static String routeName = 'ReviewWritePage';
  static String routePath = '/reviewWritePage';

  @override
  State<ReviewWritePageWidget> createState() => _ReviewWritePageWidgetState();
}

class _ReviewWritePageWidgetState extends State<ReviewWritePageWidget> {
  late ReviewWritePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedScore = 0;

  // 신규: 닉네임, 술이름 컨트롤러 추가
  late TextEditingController _nicknameController;
  late TextEditingController _sulnameController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReviewWritePageModel());
    _model.reviewWriteTextController ??= TextEditingController();
    _model.reviewWriteFocusNode ??= FocusNode();
    _nicknameController = TextEditingController();
    _sulnameController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    _nicknameController.dispose();
    _sulnameController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final reviewText = _model.reviewWriteTextController.text.trim();
    final nickname = _nicknameController.text.trim();
    final sulname = _sulnameController.text.trim();

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임을 입력해 주세요!')),
      );
      return;
    }
    if (sulname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('술 이름을 입력해 주세요!')),
      );
      return;
    }
    if (_selectedScore == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('평점을 선택해 주세요!')),
      );
      return;
    }
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 내용을 입력해 주세요!')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('reviews').add({
      'user': nickname,
      'sulname': sulname,
      'score': _selectedScore,
      'review': reviewText,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('리뷰가 등록되었습니다!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          iconTheme:
          IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            '리뷰 작성',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontStyle:
                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // 닉네임 입력
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                  child: TextFormField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      hintText: '닉네임을 입력해 주세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                // 술 이름 입력
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: TextFormField(
                    controller: _sulnameController,
                    decoration: InputDecoration(
                      labelText: '술 이름',
                      hintText: '술 이름을 입력해 주세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                // 평점
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          '평점을 선택해주세요.',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                            fontSize: 18.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: _selectedScore > index
                                    ? Color(0xFFFFCD00)
                                    : Colors.grey[300],
                                size: 32.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedScore = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                // 리뷰 작성 안내
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                            child: Text(
                              '리뷰를 입력해 주세요.',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Text(
                            '좋았던 점 혹은 아쉬운 점, 같이 먹으면 좋은 안주 등등 여러분들의 이야기를 남겨주세요!',
                            textAlign: TextAlign.center,
                            style:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ),
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 리뷰 입력
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    child: TextFormField(
                      controller: _model.reviewWriteTextController,
                      focusNode: _model.reviewWriteFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: '리뷰 작성칸',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                        ),
                        letterSpacing: 0.0,
                        lineHeight: 1.4,
                      ),
                      maxLines: 5,
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
                // 사진 첨부 안내 (버튼만)
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    '사진을 남겨주세요',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                  child: Container(
                    width: 250.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '사진 첨부',
                          style:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 등록 버튼
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      '등록하기',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
