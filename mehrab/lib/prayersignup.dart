import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mehrab/prayerlogin.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_sms/flutter_sms.dart';

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:permission_handler/permission_handler.dart';

final _formKey = GlobalKey<FormState>();

final _controller = TextEditingController();

final TextEditingController _NameController = TextEditingController();

final TextEditingController _UserNameController = TextEditingController();

final TextEditingController _EmailController = TextEditingController();

var db = FirebaseFirestore.instance;

class prayersignup extends StatefulWidget {
  _prayersignupState createState() => _prayersignupState();
}

class _prayersignupState extends State<prayersignup> {
//Sending sms with creditials

  final _controller = TextEditingController();

  final TextEditingController _password1 = TextEditingController();

  final TextEditingController _password2 = TextEditingController();

  bool validChar = true;

  var charError;

  bool equal = true;

  var equalError;

  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _password1.clear();

    _password2.clear();

    validChar = true;

    charError = null;

    bool equal = true;

    equalError = null;

    _NameController.text = '';

    _UserNameController.text = '';

    _EmailController.text = '';
  }

  bool _visible = false;

  var DuplicateUsername = false;

  var DuplicateUsernameError = '';

  var validEmail = true;

  var EmailErrormsg = '';

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'التسجيل',
                  style: TextStyle(fontFamily: 'Elmessiri'),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 20, 5, 87),
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
                        child: TextField(
                          controller: _NameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.account_circle,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: 'الاسم',
                            labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: "Elmessiri",
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _UserNameController,
                          onFieldSubmitted: validateUsername,
                          decoration: InputDecoration(
                            errorText: DuplicateUsername == true
                                ? DuplicateUsernameError
                                : null,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.account_circle,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: 'اسم المستخدم',
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
                          controller: _EmailController,
                          onFieldSubmitted: _validateEmail,
                          decoration: InputDecoration(
                            errorText:
                                validEmail == false ? EmailErrormsg : null,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.account_circle,
                                color: Color.fromRGBO(234, 217, 163, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: 'البريد الالكتروني',
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
                          obscureText: true,
                          controller: _password2,
                          onFieldSubmitted: _validate2,
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
                    Visibility(
                        visible: _visible,
                        child: Text(' جميع الحقول مطلوبة *',
                            style: TextStyle(color: Colors.red))),
                    Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              primary: Color.fromARGB(255, 20, 5, 87),
                            ),
                            child: const Text('التسجيل',
                                style: TextStyle(fontFamily: 'Elmessiri')),
                            onPressed: () {
                              if (_NameController.text.isEmpty ||
                                  _UserNameController.text.isEmpty ||
                                  _EmailController.text.isEmpty ||
                                  _password1.text.isEmpty ||
                                  _password2.text.isEmpty ||
                                  _NameController.text == '' ||
                                  _UserNameController.text == '' ||
                                  _EmailController.text == '' ||
                                  _password1.text == '' ||
                                  _password2.text == '') {
                                _toggle();
                              }

                              if (_NameController.text.isNotEmpty &&
                                  _UserNameController.text.isNotEmpty &&
                                  _EmailController.text.isNotEmpty &&
                                  _password1.text.isNotEmpty &&
                                  _password2.text.isNotEmpty &&
                                  _NameController.text != '' &&
                                  _UserNameController.text != '' &&
                                  _EmailController.text != '' &&
                                  _password1.text != '' &&
                                  _password2.text != '') {
                                _toggle1();
                              }

                              if (_password1.text.isNotEmpty &&
                                  _password2.text.isNotEmpty &&
                                  validChar == true &&
                                  _password1.text == _password2.text &&
                                  DuplicateUsername == false &&
                                  validEmail == true) {
                                var prayerpassword = _password1.text;

                                var hprayerpassword =
                                    utf8.encode(prayerpassword);

                                final PrayerData = {
                                  "الاسم": _NameController.text,
                                  "اسم المستخدم": _UserNameController.text,
                                  "الايميل": _EmailController.text,
                                  "كلمة المرور": sha256
                                      .convert(hprayerpassword)
                                      .toString(),
                                };

                                showAlertDialog(
                                  context,
                                  PrayerData,
                                );

                                setState(() {});
                              }
                            })),
                  ],
                ),
              ),
            )));
  }

  void _toggle() {
    setState(() {
      _visible = true;
    });
  }

  void _toggle1() {
    setState(() {
      _visible = false;
    });
  }

  _validateEmail(String value) async {
    var v = true;

    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      setState(() {
        validEmail = false;

        EmailErrormsg = 'الرجاء كتابة الايميل بشكل صحيح ';

        v = false;
      });
    } else if (RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      setState(() {
        validEmail = true;
      });
    }
  } //End validate email

  validateUsername(String text) async {
    var v = true;

    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('prayer').doc(text);

    DocumentSnapshot snapshot = await documentRef.get();

    if (snapshot.exists) {
      setState(() {
        DuplicateUsername = true;

        DuplicateUsernameError = "اسم المستخدم مسجّل مسبقًا";

        v = false;

        String documentId = snapshot.id;

        print('Document ID: $documentId');
      });
    } else {
      print('Document does not exist');
    }

    db.collection("prayer").doc(text).get().then((querySnapshot) {});

    if (v == true) {
      setState(() {
        DuplicateUsername = false;
      });
    }
  } //End validate username

  void _validate1(String value) {
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
  } //End validate password

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
  } //End validate confirmation passowrd

  showAlertDialog(
    BuildContext context,
    Map<String, Object> PrayerData,
  ) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("إلغاء", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("نعم", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Add(PrayerData);

        Navigator.pop(context);

        Navigator.pop(context);

        _password1.clear();

        _password2.clear();

        _NameController.clear();

        _UserNameController.clear();

        _EmailController.clear();
      },
    );

    // set up the AlertDialog

    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("التسجيل",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("هل أنت متأكد من صحة المعلومات المدخلة ؟",
            style: TextStyle(fontFamily: 'Elmessiri')),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Add(
    Map<String, dynamic> PrayerData,
  ) {
    db
        .collection('prayer')
        .doc(_UserNameController.text)

        //.doc()

        .set(PrayerData)
        .onError((e, _) => print("Error writing document: $e"));
  }
}
