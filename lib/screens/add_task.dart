import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynote/provider/userNotifier.dart';
import 'package:mynote/services/firebase_crud.dart';
import 'package:mynote/widgets/rounded_input_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String gorevAdi = "";
  String gorevAciklamasi = "";
  String gorevTarihi = "";
  String gorevSaati = "";
  CrudMethods crud = new CrudMethods();
  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('app_icon');
      var initilizationsSettings =
          new InitializationSettings(android: initializationSettingsAndroid);
      fltrNotification.initialize(initilizationsSettings,
          onSelectNotification: notificationSelected);
    });
    super.initState();
  }

  Future notificationSelected(String? payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          "Yaklaşan Göreviniz Var!!",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future _bildirimGonder(String gorevTarih, String gorevSaat) async {
    DateTime tarih = DateTime.parse("$gorevTarih $gorevSaat:00.000000");
    ////Bildirim Fonksiyonu
    var androidDetails = new AndroidNotificationDetails(
        "Piton", "myNote", "Bildirim",
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);
    var scheduledTime = tarih.add(Duration(seconds: 5));
    print("Tarih ::: " + scheduledTime.toString());
    // ignore: deprecated_member_use
    fltrNotification.schedule(1, gorevAdi, gorevAciklamasi, scheduledTime,
        generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Görev Ekle"),
        centerTitle: true,
      ),
      body: Container(
        /* height: size.height,
        width: size.width, */
        color: Colors.grey.shade900,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      RoundedInputField(
                          icon: FontAwesomeIcons.edit,
                          key: null,
                          hintText: "Görev Adını Giriniz..",
                          onChanged: (value) {
                            setState(() {
                              gorevAdi = value;
                            });
                          }),
                      RoundedInputField(
                          icon: FontAwesomeIcons.edit,
                          key: null,
                          hintText: "Görev Açıklamasını Giriniz..",
                          onChanged: (value) {
                            setState(() {
                              gorevAciklamasi = value;
                            });
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GFButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2031, 3, 5),
                                  theme: DatePickerTheme(
                                      itemStyle: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      doneStyle: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 16)), onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                setState(() {
                                  gorevTarihi =
                                      date.toUtc().toString().substring(0, 10);
                                });

                                print('confirm $gorevTarihi aa');
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            text: "Tarih seç",
                            icon: Icon(Icons.calendar_today_rounded,
                                color: Colors.white),
                            shape: GFButtonShape.pills,
                            size: GFSize.LARGE,
                            color: Colors.grey.shade800,
                          ),
                          (gorevTarihi == "")
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    "Tarih Seçilmedi",
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    gorevTarihi,
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                )
                        ],
                      ),
                      Column(
                        children: [
                          GFButton(
                            onPressed: () {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true, onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                setState(() {
                                  gorevSaati =
                                      date.toString().substring(11, 16);
                                });

                                print('confirm $gorevSaati');
                              }, currentTime: DateTime.now());
                            },
                            text: "Saat seç",
                            icon: Icon(Icons.watch_later_sharp,
                                color: Colors.white),
                            shape: GFButtonShape.pills,
                            size: GFSize.LARGE,
                            color: Colors.grey.shade800,
                          ),
                          (gorevSaati == "")
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    "Saat Seçilmedi",
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    gorevSaati,
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: size.height * 0.07,
                  width: size.width * 0.4,
                  child: GFButton(
                    onPressed: () {
                      var userNotifier =
                          Provider.of<UserNotifier>(context, listen: false);

                      // ignore: unnecessary_null_comparison
                      if (gorevAdi == "" || gorevAdi == null) {
                        showAlertDialog(context,
                            "Görev Adını Giriniz. Görev Adı Boş Bırakılamaz!");
                      } else if (gorevAciklamasi == "" ||
                          // ignore: unnecessary_null_comparison
                          gorevAciklamasi == null) {
                        showAlertDialog(context,
                            "Görev Açıklamasını Giriniz. Görev Açıklaması Boş Bırakılamaz!");
                        // ignore: unnecessary_null_comparison
                      } else if (gorevTarihi == "" || gorevTarihi == null) {
                        showAlertDialog(context,
                            "Görev Tarihi Giriniz. Görev Tarihi Boş Bırakılamaz!");
                        // ignore: unnecessary_null_comparison
                      } else if (gorevSaati == "" || gorevSaati == null) {
                        showAlertDialog(context,
                            "Görev Saati Giriniz. Görev Saati Boş Bırakılamaz!");
                      } else {
                        _bildirimGonder(gorevTarihi, gorevSaati);
                        print(gorevSaati);
                        Map<String, dynamic> gorevBilgileri = {
                          'user': userNotifier.userName,
                          'gorevAdi': gorevAdi,
                          'gorevAciklamasi': gorevAciklamasi,
                          'gorevTarihi': gorevTarihi,
                          'gorevSaati': gorevSaati,
                          'gorevDurumu': "beklemede"
                        };
                        crud.addData(gorevBilgileri);
                        print(gorevAdi +
                            "   " +
                            gorevAciklamasi +
                            "    " +
                            gorevTarihi);
                        crud.getData(context);
                        Navigator.pop(context);
                      }
                    },
                    text: "Görev Oluştur",
                    icon: Icon(Icons.add_task_outlined, color: Colors.white),
                    shape: GFButtonShape.pills,
                    size: GFSize.LARGE,
                    color: Colors.grey.shade800,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String text) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "Tamam",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "HATA",
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade800,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
