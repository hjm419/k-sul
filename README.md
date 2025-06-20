# K-Sul (우리술)

우리술(K-Sul)은 사용자의 취향에 맞는 대한민국 전통주를 추천하고, 다양한 정보를 제공하 모바일 애플리케이션입니다.

## 목차

1. [소개](#소개)
2. [설치](#설치)
3. [사용법](#사용법)
4. [시연영상](#시연-영상)
5. [권한](#권한)
6. [기술 스택](#기술-스택)
7. [문제 보고 및 지원](#문제-보고-및-지원)


## 소개

우리술(K-Sul)은 사용자가 자신의 취향에 맞는 전통주를 쉽게 찾고, 다른 사용자들과 리뷰 및 정보를 공유할 수 있는 플랫폼을 제공합니다. 카메라를 이용한 텍스트 스캔으로 간편하게 술 정보를 검색하고, 상세한 추천 시스템을 통해 개인에게 최적화된 전통주를 추천받을 수 있습니다.

## 주요 기능

* **나의 전통주 찾기:**
    * **취향 분석 추천:** 산미, 당도, 바디감, 도수, 주종 등 단계별 질문에 답변하여 개인의 취향에 맞는 전통주를 추천받을 수 있습니다.
    * **텍스트 스캔:** 카메라로 전통주 라벨을 스캔하여 간편하게 술 정보를 검색할 수 있습니다.

* **전통주 정보 제공:**
    * **상세 정보:** 주종, 도수, 용량, 제조사, 원재료 등 전통주에 대한 상세한 정보를 제공합니다.
    * **전통주 검색:** 주종별, 이름별로 원하는 전통주를 검색할 수 있습니다.
    * **양조장 지도:** '찾아가는 양조장'의 위치 정보를 지도로 확인할 수 있습니다.

* **커뮤니티:**
    * **리뷰:** 다른 사용자들의 리뷰를 확인하고 직접 리뷰를 작성하여 공유할 수 있습니다.
    * **우리술 뉴스:** 전통주와 관련된 최신 소식을 접할 수 있습니다.
    * **즐겨찾기:** 마음에 드는 술을 즐겨찾기에 추가하여 관리할 수 있습니다.

* **사용자 맞춤 기능:**
    * **로그인 및 회원가입:** 이메일, 구글, 카카오 계정을 통한 간편 로그인을 지원합니다.
    * **내 정보:** 프로필 사진 및 닉네임 수정 등 개인 정보를 관리할 수 있습니다.

## 설치

1. Google Drive 링크에서 다운로드: [다운로드 링크](https://drive.google.com/file/d/1WwtVGv5Uap0mh5SbV9uHUxM-4eio8KSv/view).
2. APK 설치:
   - 상단의 링크를 클릭하여 문해북.apk 파일을 다운로드 받습니다. 
   - 휴대폰에서 `설정 > 보안 > 알 수 없는 소스`를 허용합니다.
   - 다운로드한 APK 파일을 실행하여 설치합니다.

## 사용법

1.  **회원가입 및 로그인**
    * 앱을 처음 실행하면 나타나는 랜딩 페이지에서 시작합니다.
    * 이메일, 구글, 또는 카카오 계정을 사용하여 간편하게 회원가입하거나 로그인할 수 있습니다.

2.  **주요 기능 사용하기**
    * 로그인 후, 하단 네비게이션 바를 통해 앱의 핵심 기능들을 사용할 수 있습니다.
    * **홈:**
        * 메인 화면에서는 탁주, 약주, 과실주 등 주종별 아이콘을 탭하여 원하는 종류의 전통주를 탐색할 수 있습니다.
        * 상단의 검색 아이콘을 통해 특정 전통주를 직접 검색할 수 있습니다.
        * '우리술 뉴스' 섹션에서 전통주와 관련된 최신 소식을 확인할 수 있습니다.
    * **내 취향은? :**
        * **취향 분석:** '내 취향 분석하기'를 선택하여 산미, 당도, 바디감 등 5단계의 질문에 답변하면 취향에 맞는 술을 추천받을 수 있습니다.
        * **텍스트 스캔:** '카메라로 찾기' 기능을 이용해 전통주 라벨을 직접 스캔하여 빠르고 간편하게 해당 술의 정보를 조회할 수 있습니다.
    * **리뷰:**
        * 다양한 전통주에 대한 다른 사용자들의 리뷰를 찾아볼 수 있습니다.
        * 리뷰를 작성하고 싶은 술의 상세 페이지나 리뷰 탭의 작성 버튼을 통해 자신의 경험을 공유할 수 있습니다.
    * **내정보:**
        * 프로필 사진과 닉네임을 수정할 수 있습니다.
        * 관심 있는 술을 '즐겨찾기'에 추가하고 모아볼 수 있습니다.
        * 자신이 작성한 리뷰 목록을 확인할 수 있습니다.

## 시연 영상

영상 링크: https://www.youtube.com/watch?v=4mTtgztSkS8

## 기술 스택

* **프레임워크:** Android Studio
* **UI:** Dart
* **데이터베이스:** Firebase Firestore
* **인증:** Firebase Authentication (Email, Google Sign-In), Kakao SDK
* **데이터 소스:** CSV (traditional\_liquor\_df\_final.csv)
* **텍스트 인식:** Google ML Kit Text Recognition

## 문제 보고 및 지원

* 문제나 질문이 있을 경우, 프로젝트의 이슈 트래커를 통해 보고해 주세요.
* 추가적인 지원이 필요한 경우, 아래 이메일로 문의해 주시기 바랍니다.
    * 이메일: 0479hjm@naver.com
