import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:string_similarity/string_similarity.dart';

// 1. 술 정보를 체계적으로 관리하기 위한 데이터 클래스 정의
class LiquorInfo {
  final String name;
  final String type;
  final String abv; // 도수
  final String volume; // 용량
  final List<String> keywords;

  LiquorInfo({
    required this.name,
    required this.type,
    required this.abv,
    required this.volume,
    required this.keywords,
  });
}

class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({super.key});

  static const String routeName = 'TextRecognitionPage';
  static const String routePath = '/textRecognitionPage';

  @override
  State<TextRecognitionPage> createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  // --- 상태 변수 선언 ---
  XFile? _imageFile;
  bool _isBusy = false;
  List<LiquorInfo> _allLiquors = []; // CSV에서 로드한 모든 술 정보를 담을 리스트
  LiquorInfo? _matchedLiquor; // 최종 매칭된 술의 정보를 담을 변수

  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);

  @override
  void initState() {
    super.initState();
    _loadCsvData(); // 페이지가 시작될 때 CSV 데이터를 미리 로드
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  // --- 데이터 로딩 및 처리 로직 ---

  // 2. CSV 파일을 읽어서 LiquorInfo 객체 리스트로 변환하는 함수
  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString('assets/traditional_liquor_df_final.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    if (listData.isEmpty) return;

    List<dynamic> header = listData.first;
    // ❗️❗️ 중요: CSV 파일의 실제 컬럼명과 위치를 확인하고 수정하세요!
    int nameIndex = 2; // C열
    int typeIndex = 9; // J열
    int abvIndex = header.indexOf('도수%'); // '도수' 컬럼명을 찾아 인덱스 지정
    int volumeIndex = header.indexOf('용량'); // '용량' 컬럼명을 찾아 인덱스 지정

    if (nameIndex == -1 || typeIndex == -1) {
      print("CSV 파일에서 '제품명'(C열) 또는 '주종'(J열) 컬럼을 찾을 수 없습니다.");
      return;
    }

    List<LiquorInfo> loadedLiquors = [];
    for (var row in listData.skip(1)) {
      final name = row[nameIndex].toString();
      final type = row[typeIndex].toString();
      final abv = abvIndex != -1 ? row[abvIndex].toString() : '정보 없음';
      final volume = volumeIndex != -1 ? row[volumeIndex].toString() : '정보 없음';

      final keywords = name.toLowerCase().split(' ')..add(type.toLowerCase());

      loadedLiquors.add(LiquorInfo(
        name: name,
        type: type,
        abv: abv,
        volume: volume,
        keywords: keywords,
      ));
    }
    setState(() {
      _allLiquors = loadedLiquors;
    });
    print("CSV 로딩 완료: 총 ${_allLiquors.length}개의 술 정보 로드");
  }

  // 3. 이미지 가져오기 및 텍스트 인식, 매칭 프로세스 실행
  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _matchedLiquor = null; // 새 이미지 선택 시 이전 결과 초기화
        });
        _processImageAndMatch(InputImage.fromFilePath(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지를 가져오는 중 오류 발생: $e')),
      );
    }
  }

  // 4. OCR과 키워드 매칭을 연결하는 메인 함수
  Future<void> _processImageAndMatch(InputImage inputImage) async {
    if (_isBusy) return;
    setState(() { _isBusy = true; });

    final recognizedText = await _textRecognizer.processImage(inputImage);
    final ocrText = recognizedText.text;

    if (ocrText.trim().isEmpty) {
      print("인식된 텍스트가 없습니다.");
      setState(() { _isBusy = false; });
      return;
    }

    print('--- 인식된 텍스트 ---');
    print(ocrText);
    print('--------------------');

    findBestMatchByKeywords(ocrText);

    setState(() { _isBusy = false; });
  }

  // 5. 키워드 점수 기반으로 가장 유사한 술을 찾는 함수
  void findBestMatchByKeywords(String ocrText) {
    final Set<String> ocrWords = ocrText.replaceAll('\n', ' ').toLowerCase().split(' ').toSet();
    Map<LiquorInfo, int> scores = {};

    for (var liquor in _allLiquors) {
      int currentScore = 0;
      for (String ocrWord in ocrWords) {
        if (ocrWord.length < 2) continue;
        for (String keyword in liquor.keywords) {
          if (keyword.contains(ocrWord) || ocrWord.contains(keyword)) {
            currentScore++;
            break;
          }
        }
      }
      scores[liquor] = currentScore;
    }

    LiquorInfo? bestMatch;
    int bestScore = 0;
    scores.forEach((liquor, score) {
      if (score > bestScore) {
        bestScore = score;
        bestMatch = liquor;
      }
    });

    print('가장 유력한 후보: "${bestMatch?.name}" (매칭 점수: $bestScore)');
    const int scoreThreshold = 1; // 최소 2개 키워드가 맞아야 인정

    if (bestScore >= scoreThreshold) {
      setState(() {
        _matchedLiquor = bestMatch;
      });
    } else {
      setState(() {
        _matchedLiquor = null;
      });
    }
  }

  // --- UI 빌드 영역 ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('술 정보 스캔'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(onPressed: () => _getImage(ImageSource.gallery), icon: const Icon(Icons.photo_library), label: const Text('갤러리')),
                  ElevatedButton.icon(onPressed: () => _getImage(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text('카메라')),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 250,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: _imageFile == null ? const Text('이미지를 선택하세요') : Image.file(File(_imageFile!.path)),
                ),
              ),
              const SizedBox(height: 20),
              if (_isBusy)
                const Center(child: CircularProgressIndicator())
              else
                _buildResultWidget(), // 6. 결과를 보여주는 위젯 호출
            ],
          ),
        ),
      ),
    );
  }

  // 7. 매칭 결과를 카드 형태로 보여주는 위젯
  Widget _buildResultWidget() {
    // 매칭된 결과가 없으면, 기존의 텍스트 표시 위젯을 보여줌
    if (_matchedLiquor == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('인식된 결과가 여기에 표시됩니다.')),
      );
    }

    // 매칭된 결과가 있으면, 상세 정보를 카드 형태로 보여줌
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _matchedLiquor!.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('주종:', _matchedLiquor!.type),
            _buildInfoRow('도수:', _matchedLiquor!.abv),
            _buildInfoRow('용량:', _matchedLiquor!.volume),
          ],
        ),
      ),
    );
  }

  // 결과 행을 만드는 작은 헬퍼 위젯
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}