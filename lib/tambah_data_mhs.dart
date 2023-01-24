import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tampilan2/login.dart';
import 'package:tampilan2/main_menu.dart';

class TambahData extends StatefulWidget {
  final String username;
  TambahData({Key? key, required this.username}) : super(key: key);
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  late String nama_mk, dosen_id;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    String pesan = "";
    final response = await http.post(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/Mhs_TampilDataMhs.php"),
        body: {
          "aksi": "tambah",
          "username": widget.username,
          "nama_mk": nama_mk,
          "dosen_id": dosen_id
        });
    final data = jsonDecode(response.body);
    int value = data['value'];
    pesan = data['message'];
    if (value == 1) {
      Navigator.of(context).pop(context);
    } else {
      (BuildContext context) {
        return AlertDialog(
          title: Text('Perhatian'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(pesan),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambahkan Mata Kuliah"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "harap masukkan nama_mk";
                }
              },
              onSaved: (e) => nama_mk = e!,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nama Mata Kuliah",
              ),
            ),
            Container(
              height: 10,
            ),
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "Harap Masukkan Dosen ID";
                }
              },
              onSaved: (e) => dosen_id = e!,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Dosen ID",
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
              child: Text("Tambah"),
            )
          ],
        ),
      ),
    );
  }
}
