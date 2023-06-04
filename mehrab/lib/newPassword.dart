import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehrab/prayerlogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final TextEditingController _password1 = TextEditingController();
final TextEditingController _password2 = TextEditingController();

bool validChar = true;
var charError;
bool equal = true;
var equalError;

var db = FirebaseFirestore.instance;

class newPassword extends StatefulWidget {
  final String id;

  const newPassword({required this.id});

  _newPassword createState() => _newPassword();
}

class _newPassword extends State<newPassword> {
  void initState() {
    super.initState();
    _password1.clear();
    _password2.clear();
    validChar = true;
    charError = null;
    bool equal = true;
    equalError = null;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تغيير كلمة المرور ',
                  style: TextStyle(fontFamily: 'Elmessiri'),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 38, 25, 152),
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
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 40),
                      child: Image.asset(
                        'images/logo4.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    Container(
                        child: Text(
                      'الرجاء تغيير كلمة المرور لاستخدام حسابك',
                      style: TextStyle(fontFamily: 'Elmessiri'),
                    )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          obscureText: true,
                          controller: _password1,
                          onFieldSubmitted: _validate1,
                          decoration: InputDecoration(
                            errorText: validChar == false ? charError : null,
                            errorMaxLines: 6,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.lock,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: 'كلمة المرور',
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
                          controller: _password2,
                          onFieldSubmitted: _validate2,
                          obscureText: true,
                          decoration: InputDecoration(
                            errorText: equal == false ? equalError : null,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.lock,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: 'تأكيد كلمة المرور',
                            labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: "Elmessiri",
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Color.fromARGB(255, 38, 25, 152),
                          ),
                          child: const Text('تغيير كلمة المرور',
                              style: TextStyle(fontFamily: 'Elmessiri')),
                          onPressed: () {
                            if (_password1.text.isNotEmpty &&
                                _password2.text.isNotEmpty &&
                                validChar == true &&
                                _password1.text == _password2.text) {
                              //Validation
                              var hpassword = utf8.encode(_password1.text);
                              db.collection("Account").doc(widget.id).update({
                                'جديد': 'false',
                                'كلمة المرور': sha256
                                    .convert(hpassword)
                                    .toString() //Hashing the password
                              });

                              showAlertDialog();
                            }
                          },
                        )),
                  ],
                ),
              ),
            )));
  }

  showAlertDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("حسنًا", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(" تم تغيير كلمة المرور بنجاح",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(" نرجو منك معاودة تسجيل الدخول مرة أخرى",
            style: TextStyle(fontFamily: 'Elmessiri')),
      ),
      actions: [cancelButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _validate1(String value) {
    //Forcing password complexity
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-_!@#\$&*~]).{12,}$';
    RegExp regExp = new RegExp(pattern);
    bool valid = regExp.hasMatch(value);

    if (valid == false) {
      setState(() {
        validChar = false;
        charError =
            'يجب أن تحتوي كلمة المرور على 12 حرفًا, حرف كبير واحد, حرف صغير واحد, رقم واحد وحرف خاص واحد على الأقل';
      });
    } else {
      setState(() {
        validChar = true;
        charError = null;
      });
    }
  }

  _validate2(String value) {
    if (value != _password1.text &&
        value.isNotEmpty &&
        _password1.text.isNotEmpty) {
      setState(() {
        equalError = " الرجاء التأكد من تطابق كلمتي المرور المدخلة";
        equal = false;
      });
    }

    if (value == _password1.text &&
        value.isNotEmpty &&
        _password1.text.isNotEmpty)
      setState(() {
        equalError = null;
        equal = true;
      });
    {}
  }
}
