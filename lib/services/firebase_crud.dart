import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('gorevler');

  Future<void> addData(gorev) async {
    FirebaseFirestore.instance
        .collection('/gorevler')
        .add(gorev)
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection('gorevler').get();
  }

  updateData(newData, docid) async {
    FirebaseFirestore.instance.collection('gorevler').doc(docid).set(newData);
  }
}
