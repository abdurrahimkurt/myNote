import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(gorev) async {
    FirebaseFirestore.instance
        .collection('/gorevler')
        .add(gorev)
        .catchError((e) {
      print(e);
    });
  }
}
