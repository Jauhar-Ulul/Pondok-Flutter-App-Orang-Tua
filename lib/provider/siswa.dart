import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/siswa.dart';

// provider untuk kelola data input siswa
class DataSiswa with ChangeNotifier {
  String? token, userId;

  void updateData(tokenData, uid) {
    token = tokenData;
    userId = uid;
    notifyListeners();
  }

  // Link Firestore
  String urlMaster = "https://pondok-app-23ae1-default-rtdb.firebaseio.com/";
  List<Siswa> _allSiswa = [];

  List<Siswa> get allSiswa => _allSiswa;

  // Method tambah user
  Future<void> addSiswa(String nama, String nis) async {
    Uri url = Uri.parse("$urlMaster/siswa.json?auth=$token");
    DateTime dateNow = DateTime.now();
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "nama": nama,
          "nis": nis,
          "createdAt": dateNow.toString(),
          "userId": userId,
        }),
      );

      if (response.statusCode > 300 || response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        Siswa data = Siswa(
          id: json.decode(response.body)["name"].toString(),
          nama: nama,
          nis: nis,
          createdAt: dateNow,
        );

        _allSiswa.add(data);
        notifyListeners();
      }
    } catch (err) {
      throw (err);
    }
  }

  // Hapus data siswa
  void deleteProduct(String id) async {
    Uri url = Uri.parse("$urlMaster/siswa/$id.json?auth=$token");

    try {
      var response = await http.delete(url);

      if (response.statusCode > 300 || response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        _allSiswa.removeWhere((element) => element.id == id);
        notifyListeners();
      }
    } catch (err) {
      throw (err);
    }
  }

  Siswa selectById(String id) {
    return _allSiswa.firstWhere((element) => element.id == id);
  }

  // Inisialisasi data
  Future<void> inisialData() async {
    Uri url = Uri.parse(
        '$urlMaster/siswa.json?auth=$token&orderBy="userId"&equalTo="$userId"');

    try {
      var response = await http.get(url);

      print(response.statusCode);

      if (response.statusCode >= 300 && response.statusCode < 200) {
        throw (response.statusCode);
      } else {
        var data = json.decode(response.body) as Map<String, dynamic>;
        if (data != null) {
          data.forEach(
            (key, value) {
              Siswa prod = Siswa(
                id: key,
                nama: value["nama"],
                nis: value["nis"],
                createdAt:
                    DateFormat("yyyy-mm-dd hh:mm:ss").parse(value["createdAt"]),
              );
              _allSiswa.add(prod);
            },
          );
        }
      }
    } catch (err) {
      throw (err);
    }
  }
}
