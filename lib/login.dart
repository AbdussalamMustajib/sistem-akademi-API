import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan2/main_menu_dosen.dart';

import 'package:tampilan2/register.dart';
import 'package:tampilan2/main_menu.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, MhsSignIn, DosenSignIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  late String username, password, nama, level;
  late int id, value;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(
        Uri.parse("https://sistem-akademi-untag.000webhostapp.com/login.php"),
        body: {"username": username, "sandi": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String id = data['id'];
    String nama = data['nama'];
    String level = data['level'];
    if (value == 1 && level == "1") {
      setState(() {
        _loginStatus = LoginStatus.MhsSignIn;
        savePref(value, usernameAPI, id, nama, level);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MainMenu(signOut)));
      });
      print(pesan);
      print(nama);
    }
    if (value == 1 && level == "2") {
      setState(() {
        _loginStatus = LoginStatus.DosenSignIn;
        savePref(value, usernameAPI, id, nama, level);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MainMenuDosen(signOut)));
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(
      int value, String username, String id, String nama, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.setString("nama", nama);
      //preferences.commit();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value")!;
      level = preferences.getString("level")!;

      _loginStatus = value == 1 && level == "1"
          ? LoginStatus.MhsSignIn
          : value == 1 && level == "2"
              ? LoginStatus.DosenSignIn
              : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      //preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SIM-Akademik"),
                Image.asset(
                  "images/UNTAG.png",
                  width: 50,
                )
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _key,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Harap masukkan username";
                          }
                        },
                        onSaved: (e) => username = e!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        obscureText: _secureText,
                        onSaved: (e) => password = e!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    MaterialButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      onPressed: () {
                        check();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Register()));
                      },
                      child: Text(
                        "Klik text ini untuk membuat akun baru",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case LoginStatus.MhsSignIn:
        return MainMenu(signOut);
        break;
      case LoginStatus.DosenSignIn:
        return MainMenuDosen(signOut);
        break;
    }
  }
}
