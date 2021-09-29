import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mynote/provider/taskNotifier.dart';
import 'package:mynote/screens/empty_project.dart';
import 'package:mynote/services/firebase_crud.dart';
import 'package:provider/provider.dart';

class EndedTasks extends StatefulWidget {
  EndedTasks({Key? key}) : super(key: key);

  @override
  _EndedTasksState createState() => _EndedTasksState();
}

class _EndedTasksState extends State<EndedTasks> {
  CrudMethods crudObj = new CrudMethods();
  late QuerySnapshot task;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      crudObj.getData(context).then((results) {
        setState(() {
          task = results;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<TaskNotifier>(builder: (context, state, widget) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Geçmiş Görevler",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black87,
          child: Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /* Text(
                    'Henüz gösterilecek hiçbir görevin bulunmamaktadır.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Hemen yeni bir görev oluştur",
                    style: Theme.of(context).textTheme.headline5,
                  ), */
                  Container(
                    height: size.height * 0.8,
                    child: gecmisTasks(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget gecmisTasks() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Consumer<TaskNotifier>(builder: (context, state, widget) {
      return (state.isHaveData)
          ? ListView.builder(
              itemCount: state.task.docs.length,
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              itemBuilder: (context, i) {
                return (state.task.docs[i].get("gorevDurumu") == "Tamamlandı")
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
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: _width * 0.4,
                                              alignment: Alignment.centerLeft,
                                              child: Flexible(
                                                child: AutoSizeText(
                                                  state.task.docs[i].get("gorevAdi"),
                                                  presetFontSizes: [14],
                                                  maxLines: 6,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Container(
                                                width: _width * 0.6,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Flexible(
                                                        child: AutoSizeText(
                                                          state.task.docs[i].get(
                                                                  "gorevTarihi") +
                                                              "   ",
                                                          presetFontSizes: [12],
                                                          maxLines: 6,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Flexible(
                                                        child: AutoSizeText(
                                                          state.task.docs[i].get(
                                                              "gorevSaati"),
                                                          presetFontSizes: [12],
                                                          maxLines: 6,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.checkCircle,
                                      color: Colors.green,
                                    ),
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
                                      state.task.docs[i].get("gorevAciklamasi"),
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
          : EmptyProjectPage();
    });
  }
}
