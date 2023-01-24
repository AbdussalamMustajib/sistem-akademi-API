import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tampilan2/login.dart';
import 'package:tampilan2/main_menu.dart';

class HapusData extends StatefulWidget {
  final String id;
  final String nama;
  HapusData({Key? key, required this.id, required this.nama}) : super(key: key);
  @override
  _HapusDataState createState() => _HapusDataState();
}

class _HapusDataState extends State<HapusData> {
  late String nama_mk, dosen_id;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      hapus();
    }
  }

  hapus() async {
    final response = await http.post(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/Mhs_TampilDataMhs.php"),
        body: {
          "aksi": "hapus",
          "id": widget.id,
        });
    final data = json.decode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      Navigator.pop(context);
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hapus ${widget.nama}"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            MaterialButton(
              color: Colors.yellow,
              textColor: Colors.black,
              onPressed: () {
                hapus();
              },
              child: Text("Hapus ${widget.id}"),
            )
          ],
        ),
      ),
    );
  }
}
