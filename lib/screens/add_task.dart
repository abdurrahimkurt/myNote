import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mynote/services/firebase_crud.dart';
import 'package:mynote/widgets/rounded_input_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Görev Ekle"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                child: RoundedInputField(
                    icon: FontAwesomeIcons.edit,
                    key: null,
                    hintText: "Görev Adını Giriniz..",
                    onChanged: (value) {
                      setState(() {
                        gorevAdi = value;
                      });
                    }),
              ),
              RoundedInputField(
                  icon: FontAwesomeIcons.edit,
                  key: null,
                  hintText: "Görev Açıklamasını Giriniz..",
                  onChanged: (value) {
                    setState(() {
                      gorevAciklamasi = value;
                    });
                  }),
              /* TimePickerWidget(
                hintText: "Tarih Seçiniz",
                onChanged: (value) {
                  gorevTarihi = value;
                },
              ), */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
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
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded),
                          Text("Tarih Seç"),
                        ],
                      )),
                  ElevatedButton(
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
                      )),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    // ignore: unnecessary_null_comparison
                    if (gorevSaati == null) {
                      print("Görevin bitiş tarihini giriniz");
                      // ignore: unnecessary_null_comparison
                    } else if (gorevTarihi == null) {
                      print("Görevin bitiş saatini giriniz");
                    } else {
                      Map<String, dynamic> gorevBilgileri = {
                        'gorevAdi': gorevAdi,
                        'gorevAciklamasi': gorevAciklamasi,
                        'gorevTarihi': gorevTarihi,
                        'gorevSaati': gorevSaati,
                      };
                      crud.addData(gorevBilgileri);
                      print(gorevAdi +
                          "   " +
                          gorevAciklamasi +
                          "    " +
                          gorevTarihi);
                      print("Görevin bitiş saatini giriniz");
                    }
                  },
                  child: Text("Görevi oluştur"))
            ],
          ),
        ),
      ),
    );
  }
}
