import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:typed_data'; // 이미지 바이트 데이터를 다루기 위해 import
import 'package:image_picker/image_picker.dart'; // 이미지 피커 import
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'myinfopage_model.dart';
export 'myinfopage_model.dart';

class MyinfopageWidget extends StatefulWidget {
  const MyinfopageWidget({super.key, this.asd});

  final FFUploadedFile? asd;

  static String routeName = 'myinfopage';
  static String routePath = '/myinfopage';

  @override
  State<MyinfopageWidget> createState() => _MyinfopageWidgetState();
}

class _MyinfopageWidgetState extends State<MyinfopageWidget> {
  late MyinfopageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 닉네임과 이미지 데이터를 위젯의 로컬 상태로 관리할 변수
  late String _currentNickname;
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyinfopageModel());

    // 초기 닉네임 설정
    _currentNickname = "name";
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // 사진 변경 로직 함수 (로컬 상태만 변경)
  Future<void> _changeProfilePicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageBytes = await image.readAsBytes();
    setState(() {
      _profileImageBytes = imageBytes;
    });
  }

  // 닉네임 변경 팝업(Dialog)을 띄우는 함수 (로컬 상태 변경)
  Future<void> _showNicknameDialog() async {
    final nicknameController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('닉네임 변경'),
          content: TextField(
            controller: nicknameController,
            autofocus: true,
            decoration: InputDecoration(hintText: "새 닉네임을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('변경'),
              onPressed: () {
                if (nicknameController.text.trim().isNotEmpty) {
                  setState(() {
                    _currentNickname = nicknameController.text.trim();
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final hasImage = widget.asd != null && (widget.asd?.bytes?.isNotEmpty ?? false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '내정보',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 사진 영역을 탭할 수 있도록 InkWell로 감쌈
                          InkWell(
                            onTap: _changeProfilePicture,
                            borderRadius: BorderRadius.circular(90),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ClipOval(
                                child: _profileImageBytes != null
                                    ? Image.memory(
                                  _profileImageBytes!,
                                  width: 164,
                                  height: 164,
                                  fit: BoxFit.cover,
                                )
                                    : (hasImage
                                    ? Image.memory(
                                  widget.asd!.bytes!,
                                  width: 164,
                                  height: 164,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'assets/images/racdol.jpg',
                                  width: 164,
                                  height: 164,
                                  fit: BoxFit.cover,
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              // 'name 님'과 수정 버튼을 함께 표시
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$_currentNickname 님',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // ### 요청하신 수정 아이콘 버튼 ###
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 20.0,
                                    ),
                                    onPressed: _showNicknameDialog,
                                  ),
                                ],
                              ),
                              // '리뷰 n' 텍스트는 삭제됨
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildMenuButton(context, '즐겨찾기'),
                      _buildMenuButton(context, '나의 리뷰', onTap: () {
                        context.pushNamed(ReviewerpageWidget.routeName);
                      }),
                      _buildMenuButton(context, '정보수정'),
                      _buildMenuButton(context, '로그아웃', onTap: () async {
                        GoRouter.of(context).prepareAuthEvent();
                        await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();
                        context.goNamedAuth(Landing1Widget.routeName, context.mounted);
                      }),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  // 아래는 기존 코드와 동일합니다.
  Widget _buildMenuButton(BuildContext context, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 44.8,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFC5C5C5)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 1.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 2.0),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 85.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border.all(color: const Color(0xFFBCBCBC)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('메뉴', 'assets/images/free-icon-font-menu-burger-3917215.png', () {
            context.pushNamed(Menu1Widget.routeName);
          }),
          _buildNavItem('내 취향은?', 'assets/images/free-icon-alcohol-7090578.png', () {
            context.pushNamed(RecommendPage11Widget.routeName);
          }),
          _buildNavItem('홈', 'assets/images/free-icon-font-home-3917033.png', () {
            context.pushNamed(MainpageWidget.routeName);
          }),
          _buildNavItem('리뷰', 'assets/images/free-icon-font-feedback-alt-13085342.png', () {
            context.pushNamed(ReveiwpageWidget.routeName);
          }),
          _buildNavItem('내정보', 'assets/images/free-icon-font-user-3917559.png', () {
            context.pushNamed(MyinfopageWidget.routeName);
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, String assetPath, VoidCallback? onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 30, height: 30, fit: BoxFit.contain),
            const SizedBox(height: 5),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}