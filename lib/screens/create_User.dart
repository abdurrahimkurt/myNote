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
        crud.getData();
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
                color: Colors.black,
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedInputField(
                        hintText: "Kullanıcı Adınızı Giriniz..",
                        onChanged: (value) {
                          setState(() {
                            _newUserName = value;
                          });
                        }),
                    GFButton(
                      onPressed: () async {
                        var userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("user", _newUserName);
                        userNotifier.setUserName(_newUserName);
                        pageRoute();
                      },
                      child: Text("GİRİŞ"),
                      size: GFSize.LARGE,
                      color: Colors.grey.shade800,
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
}
