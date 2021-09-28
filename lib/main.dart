import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:mynote/provider/renkNotifier.dart';
import 'package:mynote/provider/userNotifier.dart';
import 'package:mynote/screens/add_task.dart';
import 'package:mynote/screens/create_User.dart';
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
    Size size = MediaQuery.of(context).size;
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
  }

  Widget gunluk() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return (isHaveData)
        ? ListView.builder(
            itemCount: task.docs.length,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            itemBuilder: (context, i) {
              return (task.docs[i].get("gorevDurumu") == "beklemede")
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

  Widget haftalik() {
    return Container(
      color: Colors.yellow,
    );
  }

  Widget aylik() {
    return Container(
      color: Colors.blue,
    );
  }
}
