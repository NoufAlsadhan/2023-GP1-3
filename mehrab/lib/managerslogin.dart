import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mehrab/managersPage.dart';
import 'package:mehrab/managerslogin.dart';
import 'package:mehrab/newPassword.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

final TextEditingController _nationalId = TextEditingController();
final TextEditingController _password = TextEditingController();
bool _visible = false;
bool _visible2 = false;
var idErrormag = '';
bool idError = false;
var db = FirebaseFirestore.instance;
var id;
var _new;
var mosqueId;

class ManagersLogin extends StatefulWidget {
  _managersLogin createState() => _managersLogin();
}

// ignore: camel_case_types
class _managersLogin extends State<ManagersLogin> {
  @override
  void initState() {
    super.initState();
    _nationalId.text = '';
    _password.text = '';
    _visible = false;
    _visible2 = false;
    idErrormag = '';
    idError = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: Text(
                'تسجيل الدخول',
                style: TextStyle(fontFamily: 'Elmessiri'),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 38, 25, 152),
              leading: Container(), // Remove the leading back button
              actions: [
                IconButton(
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.arrow_back),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                      child: Image.asset(
                        'images/logo4.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: validateId,
                          controller: _nationalId,
                          decoration: InputDecoration(
                            errorText: idError == true ? idErrormag : null,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.account_circle,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '* رقم الهوية',
                            labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: "Elmessiri",
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.lock,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '* كلمة المرور',
                            labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: "Elmessiri",
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _visible,
                        child: Text(' جميع الحقول مطلوبة *',
                            style: TextStyle(color: Colors.red))),
                    Visibility(
                        visible: _visible2,
                        child: Text(' رقم الهوية أو كلمة المرور غير صحيح*',
                            style: TextStyle(color: Colors.red))),
                    Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Color.fromARGB(255, 38, 25, 152),
                          ),
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(fontFamily: 'Elmessiri')),
                          onPressed: () async {
                            if (_nationalId.text.length != 10 &&
                                _nationalId.text.isNotEmpty) {
                              //Validate the length of the National ID
                              return;
                            }
                            if (_nationalId.text
                                    .isEmpty || //Validate that fields cannot be empty when submit the form
                                _password.text.isEmpty) {
                              _toggle();
                            }

                            if (_nationalId.text.isNotEmpty &&
                                _password.text.isNotEmpty) {
                              //Fields are full
                              _toggle1();

                              var val =
                                  await validateAuthentication(); //Authenticate with right credentials

                              setState(() {
                                _visible2 = val;
                              });

                              if (_visible2 == true) {
                              } else {
                                if (_new == "false") {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ManagersPage(
                                            mosqueId: mosqueId, id: id)),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => newPassword(
                                                id: id,
                                              )));
                                }
                              }
                            }
                          },
                        )),
                  ],
                ),
              ),
            )));
  }

  void _toggle() {
    //Validation
    setState(() {
      _visible = true;
    });
  }

  void _toggle1() {
    //Validation
    setState(() {
      _visible = false;
    });
  }

  Future<bool> validateAuthentication() async {
    //Validation
    bool found = true;
    var hpassword = utf8.encode(_password.text);
    var h = sha256.convert(hpassword).toString();

    final mosqueManagerRef = FirebaseFirestore.instance
        .collection('Mosque Manager')
        .doc(_nationalId.text);

    final ImamQuerySnapshot = await FirebaseFirestore.instance
        .collection('Mosque')
        .where('Imam', isEqualTo: mosqueManagerRef)
        .get();

    final MuathenQuerySnapshot = await FirebaseFirestore.instance
        .collection('Mosque')
        .where('Muathen', isEqualTo: mosqueManagerRef)
        .get();

    await db
        .collection('Account')
        .where('رقم الهوية', isEqualTo: _nationalId.text)
        .where('كلمة المرور', isEqualTo: h)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty &&
          (MuathenQuerySnapshot.size > 0 || ImamQuerySnapshot.size > 0)) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        found = false;

        id = documentSnapshot.id;
        await db.collection('Account').doc(id).get().then((docSnapshot) {
          if (docSnapshot.exists) {
            _new = docSnapshot.data()!['جديد'];
            mosqueId = docSnapshot.data()!['رقم المسجد'];
          }
        });
      }
    });
    return found;
  }

  validateId(text) {
    if (text.length != 10 && text.isNotEmpty) {
      setState(() {
        idError = true;
        idErrormag = 'رقم الهوية يجب أن يكون 10 ارقام';
      });
    } else {
      setState(() {
        idError = false;
        idErrormag = '';
      });
    }
  }
}
