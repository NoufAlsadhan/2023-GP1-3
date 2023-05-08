import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehrab/prayerlogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final _formKey = GlobalKey<FormState>();
final _controller = TextEditingController();
final TextEditingController _mosquenum = TextEditingController();
final TextEditingController _InameController = TextEditingController();
final TextEditingController _IphoneController = TextEditingController();
final TextEditingController _IidController = TextEditingController();
final TextEditingController _MnameController = TextEditingController();
final TextEditingController _MphoneController = TextEditingController();
final TextEditingController _MidController = TextEditingController();
var db = FirebaseFirestore.instance;

class createAccounts extends StatefulWidget {
  _createAccountsState createState() => _createAccountsState();
}

class _createAccountsState extends State<createAccounts> {
//Sending sms with creditials
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _IidController.text = '';
    _InameController.text = '';
    _IphoneController.text = '';
    _MnameController.text = '';
    _MidController.text = '';
    _MphoneController.text = '';
    _mosquenum.text = '';
  }

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = false;
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
                  'إنشاء حساب',
                  style: TextStyle(fontFamily: 'Elmessiri'),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 20, 5, 87),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _mosquenum,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: "   رقم المسجد",
                              labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: "Elmessiri",
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            //enabled: false,
                            controller: _InameController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: '   اسم الإمام',
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
                            controller: _IidController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText: validateid(_IidController.text),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: '   رقم هوية الإمام',
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
                            controller: _IphoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText: validatuenum(_IphoneController.text),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: '   رقم جوال الإمام',
                              labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: "Elmessiri",
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            //enabled: false,
                            controller: _MnameController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: '   اسم المؤذن',
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
                            controller: _MidController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText: validateid(_MidController.text),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: '   رقم هوية المؤذن',
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
                            controller: _MphoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText: validatuenum(_MphoneController.text),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 20, 5, 87),
                                    width: 1),
                              ),
                              labelText: '   رقم جوال المؤذن',
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
                              child: const Text('إنشاء',
                                  style: TextStyle(fontFamily: 'Elmessiri')),
                              onPressed: () {
                                bool empt = false;
                                bool falselength = false;
                                if (_IidController.text.isEmpty ||
                                    _IidController.text.isEmpty ||
                                    _IphoneController.text.isEmpty ||
                                    _MphoneController.text.isEmpty ||
                                    _mosquenum.text.isEmpty ||
                                    _InameController.text.isEmpty ||
                                    _MnameController.text.isEmpty ||
                                    _IidController.text == '' ||
                                    _IidController.text == '' ||
                                    _IphoneController.text == '' ||
                                    _MphoneController.text == '' ||
                                    _mosquenum.text == '' ||
                                    _InameController.text == '' ||
                                    _MnameController.text == '') {
                                  empt = true;
                                  _toggle();
                                }
                                if (_IidController.text.isNotEmpty &&
                                    _IidController.text.isNotEmpty &&
                                    _IphoneController.text.isNotEmpty &&
                                    _MphoneController.text.isNotEmpty &&
                                    _mosquenum.text.isNotEmpty &&
                                    _InameController.text.isNotEmpty &&
                                    _MnameController.text.isNotEmpty &&
                                    _IidController.text != '' &&
                                    _IidController.text != '' &&
                                    _IphoneController.text != '' &&
                                    _MphoneController.text != '' &&
                                    _mosquenum.text != '' &&
                                    _InameController.text != '' &&
                                    _MnameController.text != '') {
                                  empt = false;
                                  _toggle1();
                                }
                                if (_IidController.text.length != 10 ||
                                    _MidController.text.length != 10 ||
                                    _IphoneController.text.length != 10 ||
                                    _MphoneController.text.length != 10) {
                                  falselength = true;
                                }
                                if (empt == false && falselength == false) {
                                  var muathenPassword =
                                      generateRandomPassword();
                                  var hmuathenpassword =
                                      utf8.encode(muathenPassword);
                                  var imamPassword = generateRandomPassword();
                                  var himampassword = utf8.encode(imamPassword);

                                  final ImamData = {
                                    "رقم الهوية": _IidController.text,
                                    "الإسم": _InameController.text,
                                    "رقم الجوال": _IphoneController.text,
                                    "الوظيفة": "إمام",
                                    "رقم المسجد": _mosquenum.text,
                                    "كلمة المرور": sha256
                                        .convert(himampassword)
                                        .toString(),
                                  };
                                  final MuathenData = {
                                    "رقم الهوية": _MidController.text,
                                    "الإسم": _MnameController.text,
                                    "رقم الجوال": _MphoneController.text,
                                    "الوظيفة": "مؤذن",
                                    "رقم المسجد": _mosquenum.text,
                                    "كلمة المرور": sha256
                                        .convert(hmuathenpassword)
                                        .toString(),
                                  };
                                  showAlertDialog(
                                      context,
                                      ImamData,
                                      MuathenData,
                                      muathenPassword,
                                      imamPassword,
                                      _IphoneController.text,
                                      _MphoneController.text);
                                }
                                setState(() {});
                              })),
                    ],
                  ),
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

  validateid(String text) {
    if (!(text.length == 10) && text.isNotEmpty) {
      return "رقم الهوية يجب أن يكون 10 أرقام";
    }

    return null;
  }

  validatuenum(String text) {
    if (!(text.length == 10) && text.isNotEmpty) {
      return "رقم الجوال يجب أن يكون 10 أرقام";
    }
    return null;
  }

  String generateRandomPassword() {
    var random = Random.secure();
    var password = '';
    var charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$\%^&*()_+';

    for (var i = 0; i < 12; i++) {
      password += charset[random.nextInt(charset.length)];
    }

    return password;
  }

  showAlertDialog(
      BuildContext context,
      Map<String, Object> imamData,
      Map<String, Object> muathenData,
      String muathenPassword,
      String imamPassword,
      String Iphone,
      String Mphone) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("إنشاء", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        _mosquenum.clear();
        _IidController.clear();
        _IphoneController.clear();
        _InameController.clear();
        _MidController.clear();
        _MphoneController.clear();
        _MnameController.clear();

        createacc(imamData, muathenData, muathenPassword, imamPassword, Iphone,
            Mphone);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("إنشاء حساب",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Text("هل أنت متأكد من المعلومات المعطاة لإنشاء الحسابات؟",
          style: TextStyle(fontFamily: 'Elmessiri')),
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

  createacc(
      Map<String, dynamic> imamData,
      Map<String, dynamic> muathenData,
      String muathenPassword,
      String imamPassword,
      String iphone,
      String mphone) {
    db
        .collection('Mosque Manager')
        .doc()
        .set(imamData)
        .onError((e, _) => print("Error writing document: $e"));
    db
        .collection('Mosque Manager')
        .doc()
        .set(muathenData)
        .onError((e, _) => print("Error writing document: $e"));

    sending_SMS(
        'تم إنشاء حساب لك في تطبيق محراب, نرجو الدخول برقم الهوية وكلمة المرور المرفقة $imamPassword مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك للتطبيق, شكرًا لاستخدامك محراب.',
        [iphone]);

    sending_SMS(
        'تم إنشاء حساب لك في تطبيق محراب, نرجو الدخول برقم الهوية وكلمة المرور المرفقة $muathenPassword مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك للتطبيق, شكرًا لاستخدامك محراب.',
        [mphone]);
  }

  void sending_SMS(String msg, List<String> list_receipents) async {
    String send_result =
        await sendSMS(message: msg, recipients: list_receipents)
            .catchError((err) {
      print(err);
    });
    print(send_result);
  }
}
