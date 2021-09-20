import 'package:flutter/material.dart';
import 'package:mynote/provider/renkNotifier.dart';
import 'package:mynote/screens/add_task.dart';
import 'package:provider/provider.dart';

void main() {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("myNote"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Henüz gösterilecek hiçbir görevin bulunmamaktadır.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Hemen yeni bir görev oluştur",
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
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
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.notes_rounded), label: "Görevlerim"),
          BottomNavigationBarItem(icon: Icon(Icons.add_call), label: "Bugün"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_call), label: "Yakındakiler"),
          BottomNavigationBarItem(icon: Icon(Icons.add_call), label: "Tümü"),
        ],
      ),
    );
  }
}
