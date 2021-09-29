import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynote/provider/taskNotifier.dart';
import 'package:mynote/provider/userNotifier.dart';
import 'package:provider/provider.dart';

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

  getData(BuildContext context) async {
    var userNotifier = Provider.of<UserNotifier>(context, listen: false);
    var taskNotifier = Provider.of<TaskNotifier>(context, listen: false);
    QuerySnapshot task = await FirebaseFirestore.instance
        .collection('gorevler')
        .where('user', isEqualTo: userNotifier.userName)
        .get();
    taskNotifier.setTask(task);
    return task;
  }

  updateData(newData, docid) async {
    FirebaseFirestore.instance.collection('gorevler').doc(docid).set(newData);
  }
}
