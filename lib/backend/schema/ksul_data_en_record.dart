// k_sul/lib/backend/schema/ksul_data_en_record.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k_sul/flutter_flow/flutter_flow_util.dart'; // withoutNulls 사용을 위해

class KsulDataEnRecord {
  final DocumentReference reference;
  final String? ksulName;
  final String? ksulType;
  final String? ksulDetail;
  final String? ksulDgr;
  final String? ksulRegion;
  final String? ksulMaterial;
  final String? ksulImg;
  final String? specifications;
  final DateTime? createdAt; // Firestore의 Timestamp 또는 String을 DateTime으로 변환하여 저장
  final DateTime? modifiedAt; // Firestore의 Timestamp 또는 String을 DateTime으로 변환하여 저장

  KsulDataEnRecord._({
    required this.reference,
    this.ksulName,
    this.ksulType,
    this.ksulDetail,
    this.ksulDgr,
    this.ksulRegion,
    this.ksulMaterial,
    this.ksulImg,
    this.specifications,
    this.createdAt,
    this.modifiedAt,
  });

  factory KsulDataEnRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    // Firestore의 String 또는 Timestamp를 DateTime으로 안전하게 변환하는 헬퍼 함수
    DateTime? _parseDateTimeFromStringOrTimestamp(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        return DateTime.tryParse(value); // ISO 8601 형식의 문자열을 DateTime으로 변환 시도
      } else if (value is Timestamp) {
        return value.toDate(); // Timestamp를 DateTime으로 변환
      }
      // 예상치 못한 타입일 경우 null 또는 예외 처리 (여기서는 null 반환)
      return null;
    }

    return KsulDataEnRecord._(
      reference: snapshot.reference,
      ksulName: data?['ksulName'] as String?,
      ksulType: data?['ksulType'] as String?,
      ksulDetail: data?['ksulDetail'] as String?,
      ksulDgr: data?['ksulDgr'] as String?,
      ksulRegion: data?['ksulRegion'] as String?,
      ksulMaterial: data?['ksulMaterial'] as String?,
      ksulImg: data?['ksulImg'] as String?,
      specifications: data?['specifications'] as String?,
      // 수정된 날짜/시간 필드 처리
      createdAt: _parseDateTimeFromStringOrTimestamp(data?['created_at']),
      modifiedAt: _parseDateTimeFromStringOrTimestamp(data?['modified_at']),
    );
  }

  static Future<KsulDataEnRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => KsulDataEnRecord.fromSnapshot(s));

  Map<String, dynamic> toMap() => {
    'ksulName': ksulName,
    'ksulType': ksulType,
    'ksulDetail': ksulDetail,
    'ksulDgr': ksulDgr,
    'ksulRegion': ksulRegion,
    'ksulMaterial': ksulMaterial,
    'ksulImg': ksulImg,
    'specifications': specifications,
    // 데이터를 Firestore에 저장할 때는 DateTime을 다시 Timestamp로 변환하는 것이 좋습니다.
    // 하지만 이 모델은 주로 읽기용으로 사용되므로, toMap에서는 DateTime 그대로 두거나,
    // 문자열로 변환 (Firestore에 문자열로 저장하기로 결정했다면) 또는 Timestamp로 변환합니다.
    // 여기서는 DateTime을 그대로 두거나, Firestore 저장 형식에 맞춰 Timestamp로 변환합니다.
    'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'modified_at': modifiedAt != null ? Timestamp.fromDate(modifiedAt!) : null,
  }.withoutNulls; // flutter_flow_util.dart의 withoutNulls를 사용
}

// Firestore에서 데이터를 스트리밍하는 함수
Stream<List<KsulDataEnRecord>> queryKsulDataEnCollection({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  Query query = FirebaseFirestore.instance.collection('data-EN');
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return builder(query).snapshots().map((snapshot) => snapshot.docs
      .map((doc) => KsulDataEnRecord.fromSnapshot(doc))
      .toList());
}