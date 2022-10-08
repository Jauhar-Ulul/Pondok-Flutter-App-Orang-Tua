import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pondok_app/page/login_page.dart';
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

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisController = TextEditingController();

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider simpan data siswa (ERROR)
    void save(String nama, String nis) {
      try {
        Provider.of<DataSiswa>(context, listen: false)
            .addSiswa(nama, nis)
            .then((value) => Navigator.pop(context));
        //Cek Error
      } catch (err) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error Occured"),
              content: Text("Error : $err"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OKAY"),
                ),
              ],
            );
          },
        );
      }
    }

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
                title: Text('Login'),
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
                      onPressed: () =>
                          save(namaController.text, nisController.text),
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
