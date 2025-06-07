// k_sul/lib/flutter_flow/nav/nav.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart'; // FFParameters에서 deserializeParam을 위해 필요할 수 있음

import '/auth/base_auth_user_provider.dart';

// 앱의 주요 페이지 위젯들을 import 합니다.
// 실제 프로젝트에 있는 위젯들의 정확한 경로와 이름으로 수정해야 합니다.
import '/pages/mainpage/mainpage_widget.dart';
import '/landing_page/landing_1/landing1_widget.dart';
import '/login_page/auth_page/auth_page_widget.dart';
import '/recommend_page/recommend_page1_1/recommend_page11_widget.dart';
// ... 다른 페이지 위젯들도 여기에 import ...
import '/pages/searchpage/searchpage_widget.dart';
import '/recommend_page/recommend_page_result/recommend_page_result_widget.dart';
import '/pages/map/map_widget.dart';
import '/login_page/login2/login2_widget.dart';
import '/login_page/name/name_widget.dart';
import '/login_page/forgot_password2/forgot_password2_widget.dart';
import '/community/myinfopage/myinfopage_widget.dart';
import '/pages/drink_information_page/drink_information_page_widget.dart';
import '/pages/menu1/menu1_widget.dart';
import '/community/reveiwpage/reveiwpage_widget.dart';
import '/login_page/signup/signup_widget.dart';
import '/community/reviewerpage/reviewerpage_widget.dart';
import '/community/news/news_widget.dart';
import '/community/newsmain/newsmain_widget.dart';
import '/pages/review_write_page/review_write_page_widget.dart';
import '/recommend_page/favorite/favorite_widget.dart';
import '/making/myinfomodify/myinfomodify_widget.dart';
import '/pages/ranking_page/ranking_page_widget.dart';
import '/recommend_page/recommend_page1_4/recommend_page14_widget.dart';
import '/recommend_page/recommend_page1_5/recommend_page15_widget.dart';
import '/recommend_page/recommmendmain/recommmendmain_widget.dart';
import '/pages/map22/map22_widget.dart';
import '/recommend_page/recommend_page1_2/recommend_page12_widget.dart';
import '/recommend_page/recommend_page1_3/recommend_page13_widget.dart';
import '/pages/textscan_page/textscan_page_widget.dart';


import '/flutter_flow/flutter_flow_theme.dart'; // 테마
import '/flutter_flow/lat_lng.dart'; // 위도경도
import '/flutter_flow/place.dart'; // 장소
import '/flutter_flow/flutter_flow_util.dart'; // 유틸리티
import 'serialization_util.dart'; // 직렬화 유틸리티

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

import 'package:k_sul/text_recognition_page.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
  initialLocation: '/', // 앱 시작 시 기본 경로
  debugLogDiagnostics: true,
  refreshListenable: appStateNotifier,
  navigatorKey: appNavigatorKey,
  // 오류 발생 시 또는 일치하는 라우트가 없을 때 보여줄 페이지
  errorBuilder: (context, state) => appStateNotifier.loggedIn
      ? MainpageWidget() // 로그인 상태면 메인 페이지
      : Landing1Widget(), // 비로그인 상태면 랜딩 페이지
  redirect: (context, state) {
    // 앱 상태를 가져옵니다.
    final loading = appStateNotifier.loading;
    final loggedIn = appStateNotifier.loggedIn;
    final isAuthPage = state.matchedLocation == AuthPageWidget.routePath;
    final isLandingPage = state.matchedLocation == Landing1Widget.routePath;
    final isSplash = state.matchedLocation == '/';

    // 1. 로딩 중이면, 스플래시 화면에 그대로 둡니다.
    if (loading) {
      return isSplash ? null : '/';
    }

    // 2. 로딩이 끝났고, 사용자가 로그인 페이지나 랜딩 페이지에 있다면 그대로 둡니다.
    if (isAuthPage || isLandingPage) {
      return null;
    }

    // 3. 로딩이 끝났고, 사용자가 스플래시 화면에 있다면 상태에 따라 리디렉션합니다.
    if (isSplash) {
      return loggedIn ? MainpageWidget.routePath : Landing1Widget.routePath;
    }

    // 그 외의 경우는 아무것도 하지 않습니다.
    return null;
  },

  routes: [
    FFRoute(
      name: '_initialize',
      path: '/',
      // 이제 이 builder는 스플래시 화면만 담당합니다.
      builder: (context, _) => Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: Image.asset(
            'assets/images/Animation_-_1748772120918.gif',
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    FFRoute(
      name: Landing1Widget.routeName,
      path: Landing1Widget.routePath, // 예: '/landingPage'
      builder: (context, params) => Landing1Widget(),
      requireAuth: false, // 랜딩 페이지는 로그인이 필요 없음
    ),
    FFRoute(
      name: AuthPageWidget.routeName,
      path: AuthPageWidget.routePath, // 예: '/authPage'
      builder: (context, params) => AuthPageWidget(),
      requireAuth: false, // 인증 페이지는 로그인이 필요 없음
    ),
    FFRoute(
      name: MainpageWidget.routeName,
      path: MainpageWidget.routePath, // 예: '/mainPage'
      builder: (context, params) => MainpageWidget(),
      requireAuth: true, // 메인 페이지는 로그인이 필요함
    ),
    FFRoute(
      name: RecommendPage11Widget.routeName,
      path: RecommendPage11Widget.routePath,
      builder: (context, params) => RecommendPage11Widget(),
      // 이 페이지가 로그인/인증 상태에 따라 어떻게 동작해야 하는지 정의 필요
      // requireAuth: true, // 또는 false, 또는 다른 리디렉션 로직
    ),
    // 여기에 다른 모든 FFRoute 정의를 추가합니다.
    // 예시로 SearchpageWidget만 추가합니다.
    FFRoute(
      name: SearchpageWidget.routeName,
      path: SearchpageWidget.routePath,
      builder: (context, params) => SearchpageWidget(),
      // requireAuth: true, // 검색 페이지가 로그인이 필요한 경우
    ),
    FFRoute(
      name: RecommendPageResultWidget.routeName,
      path: RecommendPageResultWidget.routePath,
      builder: (context, params) => RecommendPageResultWidget(),
    ),
    FFRoute(
      name: MapWidget.routeName,
      path: MapWidget.routePath,
      builder: (context, params) => MapWidget(),
    ),
    FFRoute(
      name: Login2Widget.routeName,
      path: Login2Widget.routePath,
      builder: (context, params) => Login2Widget(),
    ),
    FFRoute(
      name: NameWidget.routeName,
      path: NameWidget.routePath,
      builder: (context, params) => NameWidget(),
    ),
    FFRoute(
      name: ForgotPassword2Widget.routeName,
      path: ForgotPassword2Widget.routePath,
      builder: (context, params) => ForgotPassword2Widget(),
    ),
    FFRoute(
      name: MyinfopageWidget.routeName,
      path: MyinfopageWidget.routePath,
      builder: (context, params) => MyinfopageWidget(),
    ),
    FFRoute(
      name: DrinkInformationPageWidget.routeName,
      path: DrinkInformationPageWidget.routePath,
      builder: (context, params) => DrinkInformationPageWidget(),
    ),
    FFRoute(
      name: Menu1Widget.routeName,
      path: Menu1Widget.routePath,
      builder: (context, params) => Menu1Widget(),
    ),
    FFRoute(
      name: ReveiwpageWidget.routeName,
      path: ReveiwpageWidget.routePath,
      builder: (context, params) => ReveiwpageWidget(),
    ),
    FFRoute(
      name: SignupWidget.routeName,
      path: SignupWidget.routePath,
      builder: (context, params) => SignupWidget(),
    ),
    FFRoute(
      name: ReviewerpageWidget.routeName,
      path: ReviewerpageWidget.routePath,
      builder: (context, params) => ReviewerpageWidget(),
    ),
    FFRoute(
      name: NewsWidget.routeName,
      path: NewsWidget.routePath,
      builder: (context, params) => NewsWidget(),
    ),
    FFRoute(
      name: NewsmainWidget.routeName,
      path: NewsmainWidget.routePath,
      builder: (context, params) => NewsmainWidget(),
    ),
    FFRoute(
      name: ReviewWritePageWidget.routeName,
      path: ReviewWritePageWidget.routePath,
      builder: (context, params) => ReviewWritePageWidget(),
    ),
    FFRoute(
      name: FavoriteWidget.routeName,
      path: FavoriteWidget.routePath,
      builder: (context, params) => FavoriteWidget(),
    ),
    FFRoute(
      name: MyinfomodifyWidget.routeName,
      path: MyinfomodifyWidget.routePath,
      builder: (context, params) => MyinfomodifyWidget(),
    ),
    FFRoute(
      name: RankingPageWidget.routeName,
      path: RankingPageWidget.routePath,
      builder: (context, params) => RankingPageWidget(),
    ),
    FFRoute(
      name: RecommendPage14Widget.routeName,
      path: RecommendPage14Widget.routePath,
      builder: (context, params) => RecommendPage14Widget(),
    ),
    FFRoute(
      name: RecommendPage15Widget.routeName,
      path: RecommendPage15Widget.routePath,
      builder: (context, params) => RecommendPage15Widget(),
    ),
    FFRoute(
      name: RecommmendmainWidget.routeName,
      path: RecommmendmainWidget.routePath,
      builder: (context, params) => RecommmendmainWidget(),
    ),
    FFRoute(
      name: Map22Widget.routeName,
      path: Map22Widget.routePath,
      builder: (context, params) => Map22Widget(),
    ),
    FFRoute(
      name: RecommendPage12Widget.routeName,
      path: RecommendPage12Widget.routePath,
      builder: (context, params) => RecommendPage12Widget(),
    ),
    FFRoute(
      name: RecommendPage13Widget.routeName,
      path: RecommendPage13Widget.routePath,
      builder: (context, params) => RecommendPage13Widget(),
    ),
    FFRoute(
      name: TextscanPageWidget.routeName,
      path: TextscanPageWidget.routePath,
      builder: (context, params) => TextscanPageWidget(),
    ),
    FFRoute(
      name: TextRecognitionPage.routeName, // 1단계에서 만든 변수 사용
      path: TextRecognitionPage.routePath,   // 1단계에서 만든 변수 사용
      builder: (context, params) => const TextRecognitionPage(),
    ),
  ].map((r) => r.toRoute(appStateNotifier)).toList(),
);

// NavParamExtensions, NavigationExtensions, GoRouterExtensions, _GoRouterStateExtensions,
// FFParameters, FFRoute, TransitionInfo, RootPageContext, GoRouterLocationExtension
// 클래스 및 확장 기능들은 FlutterFlow에서 생성된 그대로 유지합니다.
// (이전 답변에서 제공된 nav.dart 파일의 하단 부분을 참고하여 그대로 두시면 됩니다.)

// ... (기존 nav.dart 파일의 나머지 부분은 여기에 그대로 유지) ...

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
    entries
        .where((e) => e.value != null)
        .map((e) => MapEntry(e.key, e.value!)),
  );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
      String name,
      bool mounted, {
        Map<String, String> pathParameters = const <String, String>{},
        Map<String, String> queryParameters = const <String, String>{},
        Object? extra,
        bool ignoreRedirect = false,
      }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void pushNamedAuth(
      String name,
      bool mounted, {
        Map<String, String> pathParameters = const <String, String>{},
        Map<String, String> queryParameters = const <String, String>{},
        Object? extra,
        bool ignoreRedirect = false,
      }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void safePop() {
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.setRedirectLocationIfUnset(location); // AppStateNotifier에 해당 메서드가 있다고 가정
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  bool get isEmpty =>
      state.allParams.isEmpty ||
          (state.allParams.length == 1 &&
              state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
    state.allParams.entries.where(isAsyncParam).map(
          (param) async {
        final doc = await asyncParams[param.key]!(param.value)
            .onError((_, __) => null);
        if (doc != null) {
          futureParamValues[param.key] = doc;
          return true;
        }
        return false;
      },
    ),
  ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
      String paramName,
      ParamType type, {
        bool isList = false,
        List<String>? collectionNamePath,
      }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    if (param is! String) {
      return param;
    }
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
    name: name,
    path: path,
    redirect: (context, state) {
      if (appStateNotifier.shouldRedirect) {
        final redirectLocation = appStateNotifier.getRedirectLocation();
        appStateNotifier.clearRedirectLocation();
        return redirectLocation;
      }

      if (requireAuth && !appStateNotifier.loggedIn) {
        appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
        // 로그인 페이지 경로를 프로젝트에 맞게 수정하세요.
        // 예: AuthPageWidget.routePath 또는 Login2Widget.routePath 등
        return AuthPageWidget.routePath; // '/authPage' 또는 Login2Widget.routePath 등으로 변경
      }
      return null;
    },
    pageBuilder: (context, state) {
      fixStatusBarOniOS16AndBelow(context);
      final ffParams = FFParameters(state, asyncParams);
      final page = ffParams.hasFutures
          ? FutureBuilder(
        future: ffParams.completeFutures(),
        builder: (context, _) => builder(context, ffParams),
      )
          : builder(context, ffParams);
      final child = appStateNotifier.loading
          ? Container( // 스플래시 이미지 또는 로딩 인디케이터
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          // 프로젝트에 맞는 스플래시 이미지 또는 로딩 위젯 사용
          child: Image.asset(
            'assets/images/Animation_-_1748772120918.gif', // 스플래시 이미지 경로 확인
            fit: BoxFit.contain,
          ),
        ),
      )
          : page;

      final transitionInfo = state.transitionInfo;
      return transitionInfo.hasTransition
          ? CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: transitionInfo.duration,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
            PageTransition(
              type: transitionInfo.transitionType,
              duration: transitionInfo.duration,
              reverseDuration: transitionInfo.duration,
              alignment: transitionInfo.alignment,
              child: child,
            ).buildTransitions(
              context,
              animation,
              secondaryAnimation,
              child,
            ),
      )
          : MaterialPage(key: state.pageKey, child: child);
    },
    routes: routes,
  );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    // final location = GoRouterState.of(context).uri.toString(); // GoRouter 7.x.x
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString(); // GoRouter 5.x.x
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
    value: RootPageContext(true, errorRoute),
    child: child,
  );
}