import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mehrab/AdminPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:mehrab/AdminPage.dart';
import 'package:mehrab/AdminLogin.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

final TextEditingController _Username = TextEditingController();
final TextEditingController _password = TextEditingController();
bool _visible = false;
bool _visible2 = false;
var idErrormag = '';
bool idError = false;
var db = FirebaseFirestore.instance;
var id;


class AdminLogin extends StatefulWidget {
  _AdminLogin createState() => _AdminLogin();
}

class _AdminLogin extends State<AdminLogin> {
  @override
  void initState() {
    super.initState();
    _Username.text = '';
    _password.text = '';
    _visible = false;
    _visible2 = false;
    idErrormag = '';
    idError = false;
  }

  final _formKey = GlobalKey<FormState>();

  // This widget is the root of your application.
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
                ' تسجيل الدخول للمشرف',
                style: TextStyle(fontFamily: 'Elmessiri'),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 20, 5, 87),
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
                          controller: _Username,
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
                            labelText: '* اسم المستخدم',
                            labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: "Elmessiri",
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ), //Username container


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
                    ), //Password container


                    Visibility(
                        visible: _visible,
                        child: Text(' جميع الحقول مطلوبة *',
                            style: TextStyle(color: Colors.red))),
                        //error msg that appear when fields are empty

                    Visibility(
                        visible: _visible2,
                        child: Text(' إسم المستخدم  أو كلمة المرور غير صحيحة',
                            style: TextStyle(color: Colors.red))),
                        //error msg that appear when username or password are empty

                    Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Color.fromARGB(255, 20, 5, 87),
                          ),
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(fontFamily: 'Elmessiri')),
                          onPressed: () async {

                            if (_Username.text.isEmpty ||
                                _password.text.isEmpty) {
                              _visible2 = false;
                              _toggle();
                            }// th check if fields are empty

                            if (_Username.text.isNotEmpty &&
                                _password.text.isNotEmpty) {
                              _toggle1(); //to ensure that fields are not empty 

                              var val = await validateAuthentication();
                              //authenticate the admin

                              setState(() {
                                _visible2 = val;
                              });

                              if (_visible2 == true) {
                              } else {
                               
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminPage(
                                                id: id,
                                              )));
                                
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
    setState(() {
      _visible = true;
    });
  } // th check if fields are empty

  void _toggle1() {
    setState(() {
      _visible = false;
    });
  } //to ensure that fields are not empty 

  Future<bool> validateAuthentication() async {
    bool found = true;
    var hpassword = utf8.encode(_password.text);
    var h = sha256.convert(hpassword).toString();

    await db
        .collection('Admin')
        .where('اسم المستخدم', isEqualTo: _Username.text)
        .where('كلمة المرور', isEqualTo: h)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        found = false;
        id = documentSnapshot.id;
        await db.collection('Admin').doc(id).get().then((docSnapshot) {
          if (docSnapshot.exists) {
          }
        });
      }
    });
    return found;
  } // method to authenticate the admin 

  
}//end of file 




