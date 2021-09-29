import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:mynote/provider/renkNotifier.dart';
import 'package:mynote/provider/taskNotifier.dart';
import 'package:mynote/provider/userNotifier.dart';
import 'package:mynote/screens/add_task.dart';
import 'package:mynote/screens/all_tasks.dart';
import 'package:mynote/screens/create_User.dart';
import 'package:mynote/screens/empty_project.dart';
import 'package:mynote/screens/ended_task.dart';
import 'package:mynote/services/firebase_crud.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => RenkNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => TaskNotifier(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myNote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CreateUser(),
      routes: {
        "/home_page": (context) => MyHomePage(),
        "/add_task": (context) => AddTask(),
        "/ended_task": (context) => EndedTasks(),
        "/all_task": (context) => AllTasks(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CrudMethods crudObj = new CrudMethods();
  late QuerySnapshot task;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var taskNotifier = Provider.of<TaskNotifier>(context, listen: false);
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
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title:
                /* Container(
              height: 50,
              width: 40,
              child: Image.asset(
                "assets/images/myNotelogos.png",
                fit: BoxFit.fill,
              )), */
                TabBar(
              labelColor: Colors.red,
              indicatorColor: Colors.grey,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: "Bugün",
                ),
                Tab(
                  text: "Haftalık",
                ),
                Tab(
                  text: "Aylık",
                ),
              ],
            ),
            centerTitle: true,
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
                      child:
                          TabBarView(children: [gunluk(), haftalik(), aylik()]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.pushNamed(context, "/add_task");
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            unselectedItemColor: Colors.white,
            fixedColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: (i) => sayfaCagir(i),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.notes_outlined), label: "Görevlerim"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined), label: "Geçmiş Görevler")
              /*  BottomNavigationBarItem(icon: Icon(Icons.today_outlined), label: "Bugün"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_week_outlined), label: "Haftalık"),
            BottomNavigationBarItem(icon: Icon(Icons.task_rounded), label: "Aylık"), */
            ],
          ),
        ),
      );
    });
  }

  sayfaCagir(int i) {
    if (i == 0) {
      Navigator.pushNamed(context, "/all_task");
    } else {
      Navigator.pushNamed(context, "/ended_task");
    }
  }

  Widget gunluk() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Consumer<TaskNotifier>(builder: (context, state, widget) {
      return (state.isHaveData)
          ? ListView.builder(
              itemCount: state.task.docs.length,
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              itemBuilder: (context, i) {
                return (state.task.docs[i].get("gorevDurumu") == "beklemede")
                    ? (tarihBelirle(24, i, state.task))
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                isGecmisGorev(i, state.task)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .exclamationCircle,
                                                            color: Colors.red),
                                                      )
                                                    : Container(),
                                                Container(
                                                  width: _width * 0.4,
                                                  child: Flexible(
                                                    child: AutoSizeText(
                                                      state.task.docs[i]
                                                          .get("gorevAdi"),
                                                      presetFontSizes: [14],
                                                      maxLines: 6,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Container(
                                                width: _width * 0.6,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Flexible(
                                                        child: AutoSizeText(
                                                            state.task.docs[i].get(
                                                                    "gorevTarihi") +
                                                                "   ",
                                                            presetFontSizes: [
                                                              12
                                                            ],
                                                            maxLines: 6,
                                                            style: isGecmisGorev(
                                                                    i,
                                                                    state.task)
                                                                ? TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)
                                                                : TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800)),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Flexible(
                                                        child: AutoSizeText(
                                                            state.task.docs[i]
                                                                .get(
                                                                    "gorevSaati"),
                                                            presetFontSizes: [
                                                              12
                                                            ],
                                                            maxLines: 6,
                                                            style: isGecmisGorev(
                                                                    i,
                                                                    state.task)
                                                                ? TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)
                                                                : TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        GFButton(
                                          onPressed: () async {
                                            Map<String, dynamic>
                                                gorevBilgileri = {
                                              'user': state.task.docs[i]
                                                  .get("user"),
                                              'gorevAdi': state.task.docs[i]
                                                  .get("gorevAdi"),
                                              'gorevAciklamasi': state
                                                  .task.docs[i]
                                                  .get("gorevAciklamasi"),
                                              'gorevTarihi': state.task.docs[i]
                                                  .get("gorevTarihi"),
                                              'gorevSaati': state.task.docs[i]
                                                  .get("gorevSaati"),
                                              'gorevDurumu': "Tamamlandı",
                                            };
                                            crudObj.updateData(gorevBilgileri,
                                                state.task.docs[i].id);

                                            crudObj.getData(context);
                                          },
                                          child: Text("Tamamla"),
                                          color: (isGecmisGorev(i, state.task))
                                              ? Colors.red
                                              : Colors.grey.shade800,
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
                                          state.task.docs[i]
                                              .get("gorevAciklamasi"),
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
                        : Container()
                    : Container();
              })
          : EmptyProjectPage();
    });
  }

  Widget haftalik() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Consumer<TaskNotifier>(builder: (context, state, widget) {
      return (state.isHaveData)
          ? ListView.builder(
              itemCount: state.task.docs.length,
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              itemBuilder: (context, i) {
                return (state.task.docs[i].get("gorevDurumu") == "beklemede")
                    ? (tarihBelirle(168, i, state.task))
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                  state.task.docs[i]
                                                      .get("gorevAdi"),
                                                  presetFontSizes: [14],
                                                  maxLines: 1,
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
                                                          state.task.docs[i]
                                                              .get(
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
                                        GFButton(
                                          onPressed: () async {
                                            var today = DateTime.now().toUtc();

                                            Map<String, dynamic>
                                                gorevBilgileri = {
                                              'user': state.task.docs[i]
                                                  .get("user"),
                                              'gorevAdi': state.task.docs[i]
                                                  .get("gorevAdi"),
                                              'gorevAciklamasi': state
                                                  .task.docs[i]
                                                  .get("gorevAciklamasi"),
                                              'gorevTarihi': state.task.docs[i]
                                                  .get("gorevTarihi"),
                                              'gorevSaati': state.task.docs[i]
                                                  .get("gorevSaati"),
                                              'gorevDurumu': "Tamamlandı",
                                            };
                                            crudObj.updateData(gorevBilgileri,
                                                state.task.docs[i].id);
                                            crudObj.getData(context);
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
                                          state.task.docs[i]
                                              .get("gorevAciklamasi"),
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
                        : Container()
                    : Container();
              })
          : EmptyProjectPage();
    });
  }

  Widget aylik() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Consumer<TaskNotifier>(builder: (context, state, widget) {
      return (state.isHaveData)
          ? ListView.builder(
              itemCount: state.task.docs.length,
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              itemBuilder: (context, i) {
                return (state.task.docs[i].get("gorevDurumu") == "beklemede")
                    ? (tarihBelirle(720, i, state.task))
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                  state.task.docs[i]
                                                      .get("gorevAdi"),
                                                  presetFontSizes: [14],
                                                  maxLines: 1,
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
                                                          state.task.docs[i]
                                                              .get(
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
                                        GFButton(
                                          onPressed: () async {
                                            Map<String, dynamic>
                                                gorevBilgileri = {
                                              'user': state.task.docs[i]
                                                  .get("user"),
                                              'gorevAdi': state.task.docs[i]
                                                  .get("gorevAdi"),
                                              'gorevAciklamasi': state
                                                  .task.docs[i]
                                                  .get("gorevAciklamasi"),
                                              'gorevTarihi': state.task.docs[i]
                                                  .get("gorevTarihi"),
                                              'gorevSaati': state.task.docs[i]
                                                  .get("gorevSaati"),
                                              'gorevDurumu': "Tamamlandı",
                                            };
                                            crudObj.updateData(gorevBilgileri,
                                                state.task.docs[i].id);
                                            crudObj.getData(context);
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
                                          state.task.docs[i]
                                              .get("gorevAciklamasi"),
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
                        : Container()
                    : Container();
              })
          : EmptyProjectPage();
    });
  }

  ayBelirle(int i) {
    switch (i) {
      case 1:
        return DateTime.january;
      case 2:
        return DateTime.february;
      case 3:
        return DateTime.march;
      case 4:
        return DateTime.april;
      case 5:
        return DateTime.may;
      case 6:
        return DateTime.june;
      case 7:
        return DateTime.july;
      case 8:
        return DateTime.august;
      case 9:
        return DateTime.september;
      case 10:
        return DateTime.october;
      case 11:
        return DateTime.november;
      case 12:
        return DateTime.december;
      default:
        return DateTime.january;
    }
  }

  bool isGecmisGorev(int i, task) {
    var today = DateTime.now().toUtc();
    var yil = task.docs[i].get("gorevTarihi").substring(0, 4);
    var ay = task.docs[i].get("gorevTarihi").substring(5, 7);
    var gun = task.docs[i].get("gorevTarihi").substring(8, 10);
    var gorevTime =
        DateTime.utc(int.parse(yil), ayBelirle(int.parse(ay)), int.parse(gun));
    Duration difference = gorevTime.difference(today);
    if (difference.inDays < 1) {
      return true;
    } else {
      return false;
    }
  }

  bool tarihBelirle(int zaman, int i, task) {
    var today = DateTime.now().toUtc();
    var yil = task.docs[i].get("gorevTarihi").substring(0, 4);
    var ay = task.docs[i].get("gorevTarihi").substring(5, 7);
    var gun = task.docs[i].get("gorevTarihi").substring(8, 10);
    var saat = task.docs[i].get("gorevSaati").substring(0, 2);
    var dakika = task.docs[i].get("gorevSaati").substring(3, 5);
    var gorevTime = DateTime.utc(int.parse(yil), ayBelirle(int.parse(ay)),
        int.parse(gun), int.parse(saat), int.parse(dakika));
    print(saat);
    print(dakika);
    Duration difference = gorevTime.difference(today);
    if (difference.inHours <= zaman) {
      print(difference.inHours);
      return true;
    } else {
      print(difference.inHours);
      return false;
    }
  }
}
