import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:mynote/helpers/sharedPref.dart';
import 'package:mynote/init/generated/codegen_loader.g.dart';
import 'package:mynote/init/generated/locale_keys.g.dart';

import 'package:mynote/provider/languageNotifier.dart';
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
// ignore: unused_import
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await BaseSharedPrefHelper.preferencesInit();
  await EasyLocalization.ensureInitialized();
  bool isFirstLang =
      BaseSharedPrefHelper.instance.getStringValue("deviceLang") == "en";
  if (isFirstLang) {
    var lang = Platform.localeName;
    if (lang == "tr_TR" || lang == "en_US") {
      BaseSharedPrefHelper.instance
          .setStringValue("deviceLang", lang.split("_")[0]);
    } else {
      BaseSharedPrefHelper.instance.setStringValue("deviceLang", "tr");
    }
  }
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
      ChangeNotifierProvider(
        create: (context) => LanguageNotifier(),
      ),
    ],
    child: EasyLocalization(
      child: MyApp(),
      // supportedLocales: LanguageManager.instance.supportedLocales,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('tr', 'TR'),
        const Locale('de', 'DE'),
      ],
      fallbackLocale: Locale('en', 'US'),
      path: 'assets/lang',
      assetLoader: CodegenLoader(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageNotifier>(builder: (context, lang, widget) {
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
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
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('tr', 'TR'),
          const Locale('de', 'DE'),
        ],
        locale: context.locale,
      );
    });
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
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    Size size = MediaQuery.of(context).size;
    return Consumer<TaskNotifier>(builder: (context, state, widget) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: TabBar(
              labelColor: Colors.red,
              indicatorColor: Colors.grey,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: LocaleKeys.tabbar_bugun.tr(),
                ),
                Tab(
                  text: LocaleKeys.tabbar_haftalik.tr(),
                ),
                Tab(
                  text: LocaleKeys.tabbar_aylik.tr(),
                ),
              ],
            ),
            centerTitle: true,
          ),
          drawer: drawerWidget(),
          body: Stack(
            children: [
              Container(
                color: Colors.black87,
                child: Center(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        
                        Container(
                          height: size.height * 0.8,
                          child: TabBarView(
                              children: [gunluk(), haftalik(), aylik()]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: size.height * 0.38),
                  GestureDetector(
                    onTap: () {
                      _key.currentState!.openDrawer();
                    },
                    child: Container(
                      height: size.width * 0.13,
                      width: size.width * 0.08,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ],
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
                  icon: Icon(Icons.notes_outlined), label: LocaleKeys.bottommenu_gorevlerim.tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined), label: LocaleKeys.bottommenu_gecmisgorevler.tr())
              
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
                                                  child: Container(
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
                                                      child: Container(
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
                                                      child: Container(
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
                                          child: Text(LocaleKeys.tamamlabuton.tr()),
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
                                      child: Container(
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
                                              child: Container(
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
                                                      child: Container(
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
                                                      child: Container(
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
                                          child: Text(LocaleKeys.tamamlabuton.tr()),
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
                                      child: Container(
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
                                              child: Container(
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
                                                      child: Container(
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
                                                      child: Container(
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
                                          child: Text(LocaleKeys.tamamlabuton.tr()),
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
                                      child: Container(
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
    //print(saat);
    //print(dakika);
    Duration difference = gorevTime.difference(today);
    if (difference.inHours <= zaman) {
      //print(difference.inHours);
      return true;
    } else {
      //print(difference.inHours);
      return false;
    }
  }

  Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget drawerWidget() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.5,
      height: size.height,
      color: Colors.grey.shade800,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.35,
            width: size.width * 0.5,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                  child: Image.asset(
                    "assets/images/test.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  "myNote",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.035,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: size.height * 0.6,
            width: size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          GFButton(
                            color: Colors.grey.shade500,
                            onPressed: () async {
                              await context.setLocale(Locale('tr', 'TR'));
                            },
                            text: LocaleKeys.drawer_turkce.tr(),

                            ///BU ŞEKİLDE SONUNA .tr() KOYARAK YAZILACAK HER YERE
                          ),
                          GFButton(
                            color: Colors.grey.shade500,
                            onPressed: () async {
                              await context.setLocale(Locale('en', 'US'));
                            },
                            text: LocaleKeys.drawer_ingilizce.tr(),
                          ),
                          GFButton(
                            color: Colors.grey.shade500,
                            onPressed: () async {
                              await context.setLocale(Locale('de', 'DE'));
                            },
                            text: LocaleKeys.drawer_almanca.tr(),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: size.width * 0.13,
                        width: size.width * 0.08,
                        margin: EdgeInsets.only(
                            left: (size.width * 0.5) - size.width * 0.08,
                            top: size.width * 0.13),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                topLeft: Radius.circular(50))),
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GFButton(
                      color: Colors.transparent,
                      onPressed: () async {
                        launchInBrowser(
                            "http://www.linkedin.com/in/abdurrahimkurt");
                      },
                      child: Image.asset("assets/images/linkedin.png"),
                    ),
                    GFButton(
                      color: Colors.transparent,
                      onPressed: () async {
                        launchInBrowser("https://github.com/abdurrahimkurt");
                      },
                      child: Image.asset("assets/images/github.png"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
