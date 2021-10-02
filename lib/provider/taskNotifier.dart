import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TaskNotifier with ChangeNotifier {
  late QuerySnapshot _task;
  QuerySnapshot get task => _task;
  bool _isHaveData = false;
  bool get isHaveData => _isHaveData;
  setTask(QuerySnapshot task) {
    // ignore: unnecessary_null_comparison
    if (task != null && task.docs.length > 0) {
      _task = task;
      _isHaveData = true;
      //print("task güncellendi");
    } else if (task.docs.length < 1) {
      _isHaveData = false;
    } else {
      _isHaveData = true;
      //print("task güncellenemedi");
    }

    notifyListeners();
  }
}
