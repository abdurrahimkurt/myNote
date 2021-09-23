import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote/provider/renkNotifier.dart';
import 'package:mynote/screens/add_task.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => RenkNotifier(),
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
      home: MyHomePage(),
      routes: {
        "/add_task": (context) => AddTask(),
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
    return Container(
      color: Colors.black87,
    );
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
