import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pondok_app/page/login_page.dart';
import 'package:intl/intl.dart';
// Import provider
import 'package:pondok_app/provider/auth.dart';
import "package:pondok_app/provider/siswa.dart";

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSigningOut = false;
  //inisialisasi reference firebase
  final databaseRef = FirebaseDatabase.instance.ref();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisController = TextEditingController();

  late User _currentUser;
  late DatabaseReference _dbref;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    //inisialisasi _dbref menunjuk ke root/datamurid
    _dbref = FirebaseDatabase.instance.ref("/datamurid");
  }

//operasi insert data
  _createDB(String nis, String nama, String uid) {
    DateTime createdAt = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
    _dbref.push().set({
      'nama': nama,
      'nis': nis,
      'idOrtu': uid,
      'createdAt': formattedDate,
    });
    Navigator.pop(context);
    nisController.clear();
    namaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Provider simpan data siswa (ERROR)

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'UID: ${_currentUser.uid}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      // Form Input Nama & NIS (ERROR)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Tambah Murid'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.account_circle),
                          ),
                          controller: namaController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'NIS',
                            icon: Icon(Icons.add_card),
                          ),
                          controller: nisController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Button Save
                actions: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _createDB(nisController.text, namaController.text,
                            _currentUser.uid);
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
