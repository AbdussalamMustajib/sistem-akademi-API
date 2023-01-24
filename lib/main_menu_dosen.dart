import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan2/chart_mhs.dart';

class MainMenuDosen extends StatefulWidget {
  final VoidCallback signOut;
  MainMenuDosen(this.signOut);
  @override
  _MainMenuDosenState createState() => _MainMenuDosenState();
}

class _MainMenuDosenState extends State<MainMenuDosen> {
  late String angka1, angka2;
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Future<List<dynamic>> lihat_data() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/Dosen_TampilDataMhs.php"),
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
        appBar: AppBar(
          title: Text(
            "Selamat datang Bapak/Ibu $nama",
            style: TextStyle(fontSize: panjang * 0.04),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                signOut();
              },
              child: Text("Logout",
                  style: TextStyle(
                    color: Colors.black,
                  )),
            )
          ],
        ),
        body: Container(
          child: FutureBuilder<List<dynamic>>(
            future: lihat_data(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChartMhs(
                                username: snapshot.data[index]['username'],
                              ),
                            ),
                          );
                        }),
                        title: Text(snapshot.data[index]['nama']),
                        subtitle: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: panjang * 0.3,
                                    child: Text("username")),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data[index]['username']),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
