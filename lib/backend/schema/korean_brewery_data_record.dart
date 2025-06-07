import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class KoreanBreweryDataRecord extends FirestoreRecord {
  KoreanBreweryDataRecord._(
      DocumentReference reference,
      Map<String, dynamic> data,
      ) : super(reference, data) {
    _initializeFields();
  }

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "alwaysAvailable" field.
  bool? _alwaysAvailable;
  bool get alwaysAvailable => _alwaysAvailable ?? false;
  bool hasAlwaysAvailable() => _alwaysAvailable != null;

  // "breweryId" field.
  int? _breweryId;
  int get breweryId => _breweryId ?? 0;
  bool hasBreweryId() => _breweryId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "reservationAvailable" field.
  bool? _reservationAvailable;
  bool get reservationAvailable => _reservationAvailable ?? false;
  bool hasReservationAvailable() => _reservationAvailable != null;

  // "views" field.
  int? _views;
  int get views => _views ?? 0;
  bool hasViews() => _views != null;

  // "website" field.
  String? _website;
  String get website => _website ?? '';
  bool hasWebsite() => _website != null;

  // --- MODIFICATION START: breweryImg 필드 추가 ---
  // "breweryImg" field.
  String? _breweryImg;
  String get breweryImg => _breweryImg ?? '';
  bool hasBreweryImg() => _breweryImg != null;
  // --- MODIFICATION END ---

  void _initializeFields() {
    _address = snapshotData['address'] as String?;
    _alwaysAvailable = snapshotData['alwaysAvailable'] as bool?;
    _breweryId = castToType<int>(snapshotData['breweryId']);
    _name = snapshotData['name'] as String?;
    _phone = snapshotData['phone'] as String?;
    _reservationAvailable = snapshotData['reservationAvailable'] as bool?;
    _views = castToType<int>(snapshotData['views']);
    _website = snapshotData['website'] as String?;

    // --- MODIFICATION START: breweryImg 필드 초기화 로직 추가 ---
    _breweryImg = snapshotData['breweryImg'] as String?;
    // --- MODIFICATION END ---
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('korean_brewery_data');

  static Stream<KoreanBreweryDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => KoreanBreweryDataRecord.fromSnapshot(s));

  static Future<KoreanBreweryDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => KoreanBreweryDataRecord.fromSnapshot(s));

  static KoreanBreweryDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      KoreanBreweryDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static KoreanBreweryDataRecord getDocumentFromData(
      Map<String, dynamic> data,
      DocumentReference reference,
      ) =>
      KoreanBreweryDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'KoreanBreweryDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is KoreanBreweryDataRecord &&
          reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createKoreanBreweryDataRecordData({
  String? address,
  bool? alwaysAvailable,
  int? breweryId,
  String? name,
  String? phone,
  bool? reservationAvailable,
  int? views,
  String? website,
  String? breweryImg, // --- MODIFICATION: 파라미터 추가 ---
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'address': address,
      'alwaysAvailable': alwaysAvailable,
      'breweryId': breweryId,
      'name': name,
      'phone': phone,
      'reservationAvailable': reservationAvailable,
      'views': views,
      'website': website,
      'breweryImg': breweryImg, // --- MODIFICATION: 필드 추가 ---
    }.withoutNulls,
  );

  return firestoreData;
}

class KoreanBreweryDataRecordDocumentEquality
    implements Equality<KoreanBreweryDataRecord> {
  const KoreanBreweryDataRecordDocumentEquality();

  @override
  bool equals(KoreanBreweryDataRecord? e1, KoreanBreweryDataRecord? e2) {
    return e1?.address == e2?.address &&
        e1?.alwaysAvailable == e2?.alwaysAvailable &&
        e1?.breweryId == e2?.breweryId &&
        e1?.name == e2?.name &&
        e1?.phone == e2?.phone &&
        e1?.reservationAvailable == e2?.reservationAvailable &&
        e1?.views == e2?.views &&
        e1?.website == e2?.website &&
        e1?.breweryImg == e2?.breweryImg; // --- MODIFICATION: 비교 로직 추가 ---
  }

  @override
  int hash(KoreanBreweryDataRecord? e) => const ListEquality().hash([
    e?.address,
    e?.alwaysAvailable,
    e?.breweryId,
    e?.name,
    e?.phone,
    e?.reservationAvailable,
    e?.views,
    e?.website,
    e?.breweryImg // --- MODIFICATION: 해시 로직 추가 ---
  ]);

  @override
  bool isValidKey(Object? o) => o is KoreanBreweryDataRecord;
}