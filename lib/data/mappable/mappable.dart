import 'package:cloud_firestore/cloud_firestore.dart';

typedef Mapper<T> = T Function(Map<String, dynamic> map);

T getFromSnapshot<T>(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot, Mapper<T> fromMap) {
  final map = snapshot.data();
  map['id'] = snapshot.id;
  return fromMap(map);
}

List<T> getListFromSnapshot<T>(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list, Mapper<T> fromMap) {
  return list.map<T>((e) => getFromSnapshot<T>(e, fromMap)).toList();
}
