import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan2/hapus_data_mhs.dart';
import 'package:tampilan2/tambah_data_mhs.dart';
import 'package:tampilan2/update_data_mhs.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "";
  String nama = "";
  List<dynamic> data = [];
  late TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username")!;
      nama = preferences.getString("nama")!;
    });
  }

  Future<List<dynamic>> lihat_data() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://sistem-akademi-untag.000webhostapp.com/Mhs_TampilDataMhs.php?username=$username"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          'Accept': 'aplication/json',
        });

    return json.decode(response.body)['data'];
  }

  @override
  void initState() {
    getPref();
    lihat_data();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double panjang = MediaQuery.of(context).size.width;
    double tinggi = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Wellcome $nama"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.signOut();
              },
              child: Text("Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
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
                              builder: (context) => UpdateData(
                                id: snapshot.data[index]['id'],
                                nama_mk: snapshot.data[index]['nama_mk'],
                              ),
                            ),
                          );
                        }),
                        leading: IconButton(
                          onPressed: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HapusData(
                                  id: snapshot.data[index]['id'],
                                  nama: snapshot.data[index]['nama_mk'],
                                ),
                              ),
                            );
                          }),
                          icon: Icon(Icons.delete_rounded),
                        ),
                        title: Text(snapshot.data[index]['nama_mk']),
                        subtitle: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: panjang * 0.3,
                                    child: Text("ID Dosen")),
                                Text("Presensi"),
                                Text("Nilai EAS"),
                                Text("Nilai ETS"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data[index]['dosen_id']),
                                Text(snapshot.data[index]['presensi']),
                                Text(snapshot.data[index]['eas']),
                                Text(snapshot.data[index]['ets']),
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
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TambahData(
                          username: username,
                        )));
          }),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget daftarMatkul(images, nama, jadwal, ruangan, panjang, tinggi) {
    return Container(
      padding: EdgeInsets.all(5),
      width: panjang * 0.48,
      height: tinggi * 0.4,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: tinggi * 0.23,
            width: panjang * 0.45,
            child: Image.network(
              'https://source.unsplash.com/random/1200x400',
              fit: BoxFit.cover,
            ),
          ),
          Text(
            nama,
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jadwal,
                style: TextStyle(fontSize: 10),
              ),
              Text(
                ruangan,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
