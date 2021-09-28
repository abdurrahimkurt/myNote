import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  late String gorevAdi;
  late String gorevAciklamasi;
  late String gorevTarihi;
  late String gorevSaati;
  CrudMethods crud = new CrudMethods();

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
        color: Colors.black,
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

                /* TimePickerWidget(
                  hintText: "Tarih Seçiniz",
                  onChanged: (value) {
                    gorevTarihi = value;
                  },
                ), */
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GFButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2019, 6, 7),
                              theme: DatePickerTheme(
                                  headerColor: Colors.orange,
                                  backgroundColor: Colors.blue,
                                  itemStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16)), onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            gorevTarihi =
                                date.toUtc().toString().substring(0, 10);
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
                      /* ElevatedButton(
                          onPressed: () {
                            DatePicker.showTimePicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              gorevSaati = date.toString().substring(11, 16);
                              print('confirm $gorevSaati');
                            }, currentTime: DateTime.now());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.watch_later_sharp),
                              Text("Saat Seç"),
                            ],
                          ),), */
                      GFButton(
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            gorevSaati = date.toString().substring(11, 16);
                            print('confirm $gorevSaati');
                          }, currentTime: DateTime.now());
                        },
                        text: "Saat seç",
                        icon:
                            Icon(Icons.watch_later_sharp, color: Colors.white),
                        shape: GFButtonShape.pills,
                        size: GFSize.LARGE,
                        color: Colors.grey.shade800,
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
                      if (gorevAdi == "") {
                        print("Görevin bitiş tarihini giriniz");
                      } else if (gorevAciklamasi == "") {
                        print("Görevin bitiş saatini giriniz");
                      } else {
                        Map<String, dynamic> gorevBilgileri = {
                          'user' : userNotifier.userName,
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
                        print("Görevi oluştur");
                      }
                    },
                    text: "Görev Oluştur",
                    icon: Icon(Icons.watch_later_sharp, color: Colors.white),
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
}
