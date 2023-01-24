import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tampilan2/login.dart';
import 'package:tampilan2/main_menu.dart';

class UpdateData extends StatefulWidget {
  final String id, nama_mk;
  UpdateData({Key? key, required this.id, required this.nama_mk})
      : super(key: key);
  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  late double presensi, eas, ets, predikat;
  late String predikat0, predikat1, predikat2, predikat3;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      update();
    }
  }

  update() async {
    String pesan = "";
    String presensi1 = presensi.toString(),
        eas1 = eas.toString(),
        ets1 = ets.toString();

    predikat = (presensi * 0.1) + (eas * 0.5) + (ets * 0.4);
    predikat3 = predikat.toString();
    if (predikat >= 0 && predikat <= 45) {
      predikat0 = "D";
      predikat1 = "1";
      predikat2 = "K";
    }
    if (predikat >= 46 && predikat <= 50) {
      predikat0 = "D+";
      predikat1 = "1.33";
      predikat2 = "K";
    }
    if (predikat >= 51 && predikat <= 55) {
      predikat0 = "C-";
      predikat1 = "1.66";
      predikat2 = "C";
    }
    if (predikat >= 56 && predikat <= 60) {
      predikat0 = "C";
      predikat1 = "2";
      predikat2 = "C";
    }
    if (predikat >= 61 && predikat <= 65) {
      predikat0 = "C+";
      predikat1 = "2.33";
      predikat2 = "C";
    }
    if (predikat >= 66 && predikat <= 70) {
      predikat0 = "B-";
      predikat1 = "2.66";
      predikat2 = "B";
    }
    if (predikat >= 71 && predikat <= 75) {
      predikat0 = "B";
      predikat1 = "3";
      predikat2 = "B";
    }
    if (predikat >= 76 && predikat <= 80) {
      predikat0 = "B+";
      predikat1 = "3.33";
      predikat2 = "B";
    }
    if (predikat >= 81 && predikat <= 85) {
      predikat0 = "A-";
      predikat1 = "3.66";
      predikat2 = "SB";
    }
    if (predikat >= 86 && predikat <= 100) {
      predikat0 = "A";
      predikat1 = "4";
      predikat2 = "SB";
    }

    final response = await http.post(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/Mhs_TampilDataMhs.php"),
        body: {
          "aksi": "ubah",
          "presensi": presensi1,
          "eas": eas1,
          "ets": ets1,
          "nilai": predikat3,
          "id": widget.id,
          "predikat": predikat0,
          "predikat1": predikat1,
          "predikat2": predikat2
        });
    final data = json.decode(response.body);
    int value = data['value'];
    pesan = data['message'];
    if (value == 1) {
      Navigator.pop(context);
      print(pesan);
    } else {
      print(pesan);
      (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
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
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Nilai ${widget.nama_mk}"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "harap masukkan nilai presensi";
                }
              },
              onSaved: (e) => presensi = double.parse(e!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "presensi",
              ),
            ),
            Container(
              height: 10,
            ),
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "harap masukkan nilai eas";
                }
              },
              onSaved: (e) => eas = double.parse(e!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nilai EAS",
              ),
            ),
            Container(
              height: 10,
            ),
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "harap masukkan nilai ets";
                }
              },
              onSaved: (e) => ets = double.parse(e!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nilai ETS",
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
