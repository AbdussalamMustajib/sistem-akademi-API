import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tampilan2/login.dart';
import 'package:tampilan2/main_menu.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String username, password, nama, level;
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
      save();
    }
  }

  save() async {
    final response = await http.post(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/register.php"),
        body: {
          "username": username,
          "sandi": password,
          "nama": nama,
          "level": level
        });
    print(jsonDecode(response.body));
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        print(pesan);
      });
    } else {
      print(pesan);
      _showMyDialog(pesan);
    }
  }

  Future<void> _showMyDialog(String pesan) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(pesan),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(
              child: TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return "harap masukkan username";
                  }
                },
                onSaved: (e) => username = e!,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "username",
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              child: TextFormField(
                obscureText: _secureText,
                onSaved: (e) => password = e!,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              child: TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Harap masukkan nama";
                  }
                },
                onSaved: (e) => nama = e!,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nama pengguna",
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              child: TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Harap masukkan level";
                  }
                },
                onSaved: (e) => level = e!,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "level pengguna",
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            MaterialButton(
              color: Colors.yellow,
              textColor: Colors.black,
              onPressed: () {
                check();
              },
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
