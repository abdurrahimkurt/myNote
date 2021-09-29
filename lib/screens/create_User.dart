import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynote/provider/userNotifier.dart';
import 'package:mynote/services/firebase_crud.dart';
import 'package:mynote/widgets/rounded_input_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateUser extends StatefulWidget {
  CreateUser({Key? key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  String _userName = "await";
  String _newUserName = "";
  CrudMethods crud = new CrudMethods();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      sharedPref();
    });
    super.initState();
  }

  sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userNotifier = Provider.of<UserNotifier>(context, listen: false);
    setState(() {
      if (prefs.getString("user") == null || prefs.getString("user") == "") {
        _userName = "newUser";
      } else {
        _userName = prefs.getString("user")!;
        userNotifier.setUserName(_userName);
        crud.getData(context);
        pageRoute();
      }
    });
  }

  pageRoute() {
    Navigator.pushNamedAndRemoveUntil(context, "/home_page", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: (_userName == "newUser")
            ? Container(
                alignment: Alignment.center,
                color: Colors.grey.shade800,
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.width * 0.4,
                      width: size.width * 0.4,
                      child: Image.asset(
                        "assets/images/test.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    RoundedInputField(
                        hintText: "Kullanıcı Adınızı Giriniz..",
                        onChanged: (value) {
                          setState(() {
                            _newUserName = value;
                          });
                        }),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    GFButton(
                      onPressed: () async {
                        // ignore: unnecessary_null_comparison
                        if (_newUserName != "" && _newUserName != null) {
                          var userNotifier =
                              Provider.of<UserNotifier>(context, listen: false);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("user", _newUserName);
                          userNotifier.setUserName(_newUserName);
                          pageRoute();
                        } else {
                          showAlertDialog(context, "Kullanıcı Adını Giriniz!");
                        }
                      },
                      child: Text("GİRİŞ"),
                      size: GFSize.LARGE,
                      color: Colors.grey.shade900,
                    ),
                  ],
                ),
              )
            : Container(
                alignment: Alignment.center,
                color: Colors.black,
                height: size.height,
                width: size.width,
                child: CircularProgressIndicator()),
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
