import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChartMhs extends StatefulWidget {
  final String username;
  ChartMhs({Key? key, required this.username}) : super(key: key);
  @override
  _ChartMhs createState() => _ChartMhs();
}

class _ChartMhs extends State<ChartMhs> {
  late String angka1, angka2;
  signOut() {
    setState(() {});
  }

  Future<List<dynamic>> lihat_data() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/Mhs_TampilDataMhs.php?username=${widget.username}"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Accept': 'aplication/json',
        });
    return json.decode(response.body)['data'];
  }

  String username = "", nama = "";
  late TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username")!;
      nama = preferences.getString("nama")!;
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
    double panjang = MediaQuery.of(context).size.width;
    double tinggi = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: Text("Nilai ${widget.username}")),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(),
                columnWidths: <int, TableColumnWidth>{
                  0: FixedColumnWidth(panjang * 0.3),
                  1: FixedColumnWidth(panjang * 0.15),
                  2: FixedColumnWidth(panjang * 0.15),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(children: [
                    Container(
                      color: Colors.amber,
                      width: (panjang - 20) * 0.3,
                      height: (tinggi - 20) * 0.1,
                      child: Center(
                        child: Text(
                          "Mata Kuliah",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.amber,
                      width: (panjang - 20) * 0.3,
                      height: (tinggi - 20) * 0.1,
                      child: Center(
                        child: Text(
                          "Nilai AKhir",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.amber,
                      width: (panjang - 20) * 0.3,
                      height: (tinggi - 20) * 0.1,
                      child: Center(
                        child: Text(
                          "Nilai Skala 1-4",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.amber,
                      width: (panjang - 20) * 0.3,
                      height: (tinggi - 20) * 0.1,
                      child: Center(
                        child: Text(
                          "Predikat",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.amber,
                      width: (panjang - 20) * 0.3,
                      height: (tinggi - 20) * 0.1,
                      child: Center(
                        child: Text(
                          "Klasifikasi Sikap",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              FutureBuilder<List<dynamic>>(
                future: lihat_data(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Table(
                            border: TableBorder.all(),
                            columnWidths: <int, TableColumnWidth>{
                              0: FixedColumnWidth(panjang * 0.3),
                              1: FixedColumnWidth(panjang * 0.15),
                              2: FixedColumnWidth(panjang * 0.15),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: [
                                Text(
                                  snapshot.data[index]['nama_mk'],
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  snapshot.data[index]['nilai'],
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  snapshot.data[index]['predikat1'],
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  snapshot.data[index]['predikat'],
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  snapshot.data[index]['predikat2'],
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ],
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
