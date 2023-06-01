import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mehrab/createAccounts.dart';
import 'package:mehrab/prayerlogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mehrab/unauthorized.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:permission_handler/permission_handler.dart';

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

class createUpdatedAccounts extends StatefulWidget {
  final String id;
  final String option;

  const createUpdatedAccounts(
      {super.key,
      required this.id,
      required this.option //received from managers login page to know what exact mosque to fetch its data
      });
  _createUpdatedAccounts createState() => _createUpdatedAccounts();
}

class _createUpdatedAccounts extends State<createUpdatedAccounts> {
//Sending sms with creditials
  final _controller = TextEditingController();
  var visibleImam;
  var visibleMuathen;
  @override
  void initState() {
    super.initState();
    visible();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = false;
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
                'إنشاء حساب',
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
              child: SingleChildScrollView(
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
                            child: widget.option == 'option3'
                                ? Text(
                                    'إنشاء حسابات الإمام والمؤذن الجديدة',
                                    style: TextStyle(fontFamily: 'Elmessiri'),
                                  )
                                : widget.option == 'option1'
                                    ? Text('إنشاء حساب الإمام الجديد',
                                        style:
                                            TextStyle(fontFamily: 'Elmessiri'))
                                    : Text('إنشاء حساب المؤذن الجديد',
                                        style: TextStyle(
                                            fontFamily: 'Elmessiri'))),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
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
                                labelText: "رقم المسجد",
                                labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Elmessiri",
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: visibleImam,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                enabled: false,
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
                        ),
                        Visibility(
                          visible: visibleImam,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                enabled: false,
                                controller: _IidController,
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
                                  labelText: '   رقم هوية الإمام',
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Elmessiri",
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: visibleImam,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                enabled: false,
                                controller: _IphoneController,
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
                                  labelText: '   رقم جوال الإمام',
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Elmessiri",
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: visibleMuathen,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                enabled: false,
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
                        ),
                        Visibility(
                          visible: visibleMuathen,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                enabled: false,
                                controller: _MidController,
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
                                  labelText: '   رقم هوية المؤذن',
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Elmessiri",
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: visibleMuathen,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                enabled: false,
                                controller: _MphoneController,
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
                                  labelText: '   رقم جوال المؤذن',
                                  labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: "Elmessiri",
                                      fontSize: 12),
                                ),
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
                                child: const Text('إنشاء',
                                    style: TextStyle(fontFamily: 'Elmessiri')),
                                onPressed: () {
                                  bool newP = true;
                                  //All inputs are in the correct form
                                  if (widget.option == 'option3') {
                                    var imamPassword = generateRandomPassword();
                                    var himampassword =
                                        utf8.encode(imamPassword);

                                    final ImamData = {
                                      "رقم الهوية": _IidController.text,
                                      "الإسم": _InameController.text,
                                      "رقم الجوال": _IphoneController.text,
                                      "الوظيفة": "إمام",
                                      "رقم المسجد": _mosquenum.text,
                                      "كلمة المرور": sha256
                                          .convert(himampassword)
                                          .toString(), //Hash
                                      "جديد": newP,
                                    };

                                    var muathenPassword =
                                        generateRandomPassword();
                                    var hmuathenpassword =
                                        utf8.encode(muathenPassword);
                                    final MuathenData = {
                                      "رقم الهوية": _MidController.text,
                                      "الإسم": _MnameController.text,
                                      "رقم الجوال": _MphoneController.text,
                                      "الوظيفة": "مؤذن",
                                      "رقم المسجد": _mosquenum.text,
                                      "كلمة المرور": sha256
                                          .convert(hmuathenpassword)
                                          .toString(),
                                      "جديد": newP,
                                    };
                                    createacc(
                                        ImamData,
                                        MuathenData,
                                        muathenPassword,
                                        imamPassword,
                                        _IphoneController.text,
                                        _MphoneController.text);

                                    setState(() {});
                                    showAlertDialog2();
                                  } else {
                                    if (widget.option == 'option1') {
                                      var imamPassword =
                                          generateRandomPassword();
                                      var himampassword =
                                          utf8.encode(imamPassword);

                                      final ImamData = {
                                        "رقم الهوية": _IidController.text,
                                        "الإسم": _InameController.text,
                                        "رقم الجوال": _IphoneController.text,
                                        "الوظيفة": "إمام",
                                        "رقم المسجد": _mosquenum.text,
                                        "كلمة المرور": sha256
                                            .convert(himampassword)
                                            .toString(), //Hash
                                        "جديد": newP,
                                      };
                                      createOneAcc(ImamData, imamPassword,
                                          _IphoneController.text);
                                      showAlertDialog2();
                                    } else {
                                      if (widget.option == 'option2') {
                                        var muathenPassword =
                                            generateRandomPassword();
                                        var hmuathenpassword =
                                            utf8.encode(muathenPassword);
                                        final MuathenData = {
                                          "رقم الهوية": _MidController.text,
                                          "الإسم": _MnameController.text,
                                          "رقم الجوال": _MphoneController.text,
                                          "الوظيفة": "مؤذن",
                                          "رقم المسجد": _mosquenum.text,
                                          "كلمة المرور": sha256
                                              .convert(hmuathenpassword)
                                              .toString(),
                                          "جديد": newP,
                                        };
                                        createOneAcc(
                                            MuathenData,
                                            muathenPassword,
                                            _MphoneController.text);
                                        showAlertDialog2();
                                      }
                                    }
                                  }
                                })),
                        SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  String generateRandomPassword() {
    //Generating random password with 12 complexity
    var random = Random.secure();
    var password = '';
    var charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$\%^&*()_+';

    for (var i = 0; i < 12; i++) {
      password += charset[random.nextInt(charset.length)];
    }

    return password;
  }

  createacc(
      //Creating the acc and adding it to the database
      Map<String, dynamic> imamData,
      Map<String, dynamic> muathenData,
      String muathenPassword,
      String imamPassword,
      String iphone,
      String mphone) {
    db
        .collection('Account')
        .doc()
        .set(imamData)
        .onError((e, _) => print("Error writing document: $e"));
    db
        .collection('Account')
        .doc()
        .set(muathenData)
        .onError((e, _) => print("Error writing document: $e"));

    sending_SMS(
        //Sending SMS with credentials
        'تم إنشاء حساب لك في تطبيق محراب, نرجو الدخول برقم الهوية وكلمة المرور المرفقة $imamPassword مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك للتطبيق, شكرًا لاستخدامك محراب.',
        [iphone]);

    sending_SMS(
        'تم إنشاء حساب لك في تطبيق محراب, نرجو الدخول برقم الهوية وكلمة المرور المرفقة $muathenPassword مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك للتطبيق, شكرًا لاستخدامك محراب.',
        [mphone]);
  }

  showAlertDialog2() {
    // set up the buttons

    Widget continueButton = TextButton(
      child: Text("حسنًا", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("إنشاء حساب",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: widget.option == 'option3'
            ? Text("تم إنشاء كل من حساب الإمام والمؤذن بنجاح!",
                style: TextStyle(fontFamily: 'Elmessiri'))
            : widget.option == 'option1'
                ? Text("تم إنشاء حساب الإمام بنجاح!",
                    style: TextStyle(fontFamily: 'Elmessiri'))
                : Text("تم إنشاء حساب المؤذن بنجاح!",
                    style: TextStyle(fontFamily: 'Elmessiri')),
      ),
      actions: [
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

  void sending_SMS(String msg, List<String> list_receipents) async {
    //Sending the sms without redirecting to the sms app
    if (await Permission.sms.request().isGranted) {
      String send_result = await sendSMS(
              message: msg, recipients: list_receipents, sendDirect: true)
          .catchError((err) {
        print(err);
      });
      print(send_result);
    }
  }

  void visible() {
    setState(() {
      _mosquenum.text = widget.id;
    });
    if (widget.option == 'option1' || widget.option == 'option3') {
      setState(() {
        visibleImam = true;
      });

      fillImamFields();
    } else {
      setState(() {
        visibleImam = false;
      });
    }

    if (widget.option == 'option2' || widget.option == 'option3') {
      setState(() {
        visibleMuathen = true;
      });

      fillMuathenFields();
    } else {
      setState(() {
        visibleMuathen = false;
      });
    }
  }

  Future<void> fillImamFields() async {
    var docRef = db.collection("Mosque").doc(_mosquenum.text);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists && docSnapshot != null) {
      var data = docSnapshot.data();
      DocumentReference imamRef = data!["Imam"];
      DocumentSnapshot imamDocSnapshot = await imamRef.get();

      if (imamDocSnapshot.exists && imamDocSnapshot != null) {
        _InameController.text = imamDocSnapshot.get('الاسم');

        _IphoneController.text = imamDocSnapshot.get('رقم الجوال');

        _IidController.text = imamDocSnapshot.id;
      }
    }
  }

  Future<void> fillMuathenFields() async {
    var docRef = db.collection("Mosque").doc(_mosquenum.text);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists && docSnapshot != null) {
      var data = docSnapshot.data();

      DocumentReference muathenRef = data!["Muathen"];
      DocumentSnapshot muathenDocSnapshot = await muathenRef.get();
      if (muathenDocSnapshot.exists && muathenDocSnapshot != null) {
        _MnameController.text = muathenDocSnapshot.get('الاسم');

        _MphoneController.text = muathenDocSnapshot.get('رقم الجوال');

        _MidController.text = muathenDocSnapshot.id;
      }
    }
  }

  void createOneAcc(Map<String, Object> Data, String Password, String text) {
    db
        .collection('Account')
        .doc()
        .set(Data)
        .onError((e, _) => print("Error writing document: $e"));

    sending_SMS(
        //Sending SMS with credentials
        'تم إنشاء حساب لك في تطبيق محراب, نرجو الدخول برقم الهوية وكلمة المرور المرفقة $Password مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك للتطبيق, شكرًا لاستخدامك محراب.',
        [text]);
  }
}
