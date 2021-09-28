import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:mynote/services/firebase_crud.dart';

class EndedTasks extends StatefulWidget {
  EndedTasks({Key? key}) : super(key: key);

  @override
  _EndedTasksState createState() => _EndedTasksState();
}

class _EndedTasksState extends State<EndedTasks> {
  CrudMethods crudObj = new CrudMethods();
  late QuerySnapshot task;
  bool isHaveData = false;
  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        task = results;
        isHaveData = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Geçmiş Görevler",
          style: TextStyle(color: Colors.grey.shade800),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget gunluk() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return (isHaveData)
        ? ListView.builder(
            itemCount: task.docs.length,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            itemBuilder: (context, i) {
              return (task.docs[i].get("gorevDurumu") == "Tamamlandı")
                  ? Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.all(5),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          width: _width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: _width * 0.6,
                                        child: Flexible(
                                          child: AutoSizeText(
                                            task.docs[i].get("gorevAdi"),
                                            presetFontSizes: [14],
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.6,
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Flexible(
                                                child: AutoSizeText(
                                                  task.docs[i]
                                                      .get("gorevTarihi"),
                                                  presetFontSizes: [12],
                                                  maxLines: 6,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Flexible(
                                                child: AutoSizeText(
                                                  task.docs[i]
                                                      .get("gorevSaati"),
                                                  presetFontSizes: [12],
                                                  maxLines: 6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  GFButton(
                                    onPressed: () async {
                                      Map<String, dynamic> gorevBilgileri = {
                                        'user': task.docs[i].get("user"),
                                        'gorevAdi':
                                            task.docs[i].get("gorevAdi"),
                                        'gorevAciklamasi':
                                            task.docs[i].get("gorevAciklamasi"),
                                        'gorevTarihi':
                                            task.docs[i].get("gorevTarihi"),
                                        'gorevSaati':
                                            task.docs[i].get("gorevSaati"),
                                        'gorevDurumu': "Tamamlandı",
                                      };
                                      crudObj.updateData(
                                          gorevBilgileri, task.docs[i].id);
                                    },
                                    child: Text("Tamamla"),
                                    color: Colors.grey.shade800,
                                    padding: EdgeInsets.zero,
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                              Container(
                                width: _width * 0.8,
                                child: Flexible(
                                  child: AutoSizeText(
                                    task.docs[i].get("gorevAciklamasi"),
                                    presetFontSizes: [12],
                                    maxLines: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container();
            })
        : Container(
            height: _width * 0.5,
            width: _width * 0.5,
            child: CircularProgressIndicator());
  }
}
