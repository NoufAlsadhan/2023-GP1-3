import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';
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
final TextEditingController _InameController = TextEditingController();
final TextEditingController _IphoneController = TextEditingController();
final TextEditingController _IidController = TextEditingController();
final TextEditingController _MnameController = TextEditingController();
final TextEditingController _MphoneController = TextEditingController();
final TextEditingController _MidController = TextEditingController();
var db = FirebaseFirestore.instance;

class createAccounts extends StatefulWidget {
  final String? mnum;

  const createAccounts({this.mnum});
  _createAccountsState createState() => _createAccountsState();
}

class _createAccountsState extends State<createAccounts> {
//Sending sms with creditials
  final _controller = TextEditingController();
  final TextEditingController _mosquenum = TextEditingController();
  bool enable = true;

  @override
  void initState() {
    super.initState();
    _IidController.text = '';
    _InameController.text = '';
    _IphoneController.text = '';
    _MnameController.text = '';
    _MidController.text = '';
    _MphoneController.text = '';
    if (widget.mnum != '' && widget.mnum != null) {
      _mosquenum.text = widget.mnum.toString();
      _isDuplicate(widget.mnum!);
      enable = false;
    }
  }

  bool _visible = false;
  var DuplicateNum = false;
  var DuplicateNumError = '';
  var validIdI = true;
  var validIdM = true;
  var idErrorMessageI = '';
  var idErrorMessageM = '';
  var validPhoneI = true;
  var validPhoneM = true;
  var numberErrorMessageI = '';
  var numberErrorMessageM = '';

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
                    if (widget.mnum != '' && widget.mnum != null) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background2.jpg"),
                  fit: BoxFit.fitHeight,
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
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: enable,
                              controller: _mosquenum,
                              onFieldSubmitted: _isDuplicate,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText:
                                    DuplicateNum ? DuplicateNumError : null,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 20, 5, 87),
                                      width: 1),
                                ),
                                labelText: " * رقم المسجد",
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
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _IidController,
                              onFieldSubmitted: validateidI,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText:
                                    validIdI == false ? idErrorMessageI : null,
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
                              enabled: false,
                              controller: _IphoneController,
                              onFieldSubmitted: validatuenumI,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText: validPhoneI == false
                                    ? numberErrorMessageI
                                    : null,
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
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _MidController,
                              onFieldSubmitted: validateidM,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText:
                                    validIdM == false ? idErrorMessageM : null,
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
                              enabled: false,
                              controller: _MphoneController,
                              onFieldSubmitted: validatuenumM,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText: validPhoneM == false
                                    ? numberErrorMessageM
                                    : null,
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
                                  primary: Color.fromARGB(255, 38, 25, 152),
                                ),
                                child: const Text('إنشاء',
                                    style: TextStyle(fontFamily: 'Elmessiri')),
                                onPressed: () {
                                  //Validations
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
                                    _toggle(); //All fields are required
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
                                  if (empt == false &&
                                      falselength == false &&
                                      DuplicateNum == false &&
                                      validIdI == true &&
                                      validIdM == true &&
                                      validPhoneI == true &&
                                      validPhoneM == true) {
                                    //All inputs are in the correct form
                                    var muathenPassword =
                                        generateRandomPassword();
                                    var hmuathenpassword =
                                        utf8.encode(muathenPassword);
                                    var imamPassword = generateRandomPassword();
                                    var himampassword =
                                        utf8.encode(imamPassword);
                                    bool newP = true;

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
              ),
            )));
  }

  void _toggle() {
    //Validating
    setState(() {
      _visible = true;
    });
  }

  void _toggle1() {
    //Validating
    setState(() {
      _visible = false;
    });
  }

  validateidI(String text) {
    //Validating
    var v = true;
    if (!(text.length == 10) && text.isNotEmpty) {
      setState(() {
        validIdI = false;
        idErrorMessageI = "رقم الهوية يجب أن يكون 10 أرقام";
        v = false;
      });
    }

    db
        .collection("Mosque Manager")
        .where('رقم الهوية', isEqualTo: text)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          validIdI = false;
          idErrorMessageI = "رقم الهوية لا يمكن استخدامه ";
          v = false;
        });
      }
    });

    if (v == true) {
      setState(() {
        validIdI = true;
      });
    }
  }

  validatuenumI(String text) {
    //Validating
    var v = true;
    if (!(text.length == 10) && text.isNotEmpty) {
      setState(() {
        validPhoneI = false;
        numberErrorMessageI = 'رقم الجوال يجب أن يكون 10 أرقام';
        v = false;
      });
    } else if (!text.startsWith('05')) {
      setState(() {
        validPhoneI = false;
        numberErrorMessageI = 'رقم الجوال يجب أن يبدأ بـ 05';
        v = false;
      });
    }

    if (v == true) {
      setState(() {
        validPhoneI = true;
      });
    }
  }

  validateidM(String text) {
    //Validating
    var v = true;
    if (!(text.length == 10) && text.isNotEmpty) {
      setState(() {
        validIdM = false;
        idErrorMessageM = "رقم الهوية يجب أن يكون 10 أرقام";
        v = false;
      });
    }

    db
        .collection("Account")
        .where('رقم الهوية', isEqualTo: text)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          validIdM = false;
          idErrorMessageM = "رقم الهوية لا يمكن استخدامه ";
          v = false;
        });
      }
    });

    if (v == true) {
      setState(() {
        validIdM = true;
      });
    }
  }

  validatuenumM(String text) {
    //Validating
    var v = true;
    if (!(text.length == 10) && text.isNotEmpty) {
      setState(() {
        validPhoneM = false;
        numberErrorMessageM = 'رقم الجوال يجب أن يكون 10 أرقام';
        v = false;
      });
    }

    if (!text.startsWith('05')) {
      setState(() {
        validPhoneM = false;
        numberErrorMessageM = 'رقم الجوال يجب أن يبدأ بـ 05';
        v = false;
      });
    }

    if (v == true) {
      setState(() {
        validPhoneM = true;
      });
    }
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
      child: Text("إلغاء",
          style: TextStyle(fontFamily: 'Elmessiri', color: Colors.red)),
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
        Navigator.pop(context);
        showAlertDialog2();
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
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("هل أنت متأكد من المعلومات المعطاة لإنشاء الحسابات؟",
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
        'تم تأكيد التحاقك بتطبيق محراب, نرجو استخدام رقم الهوية الوطنية وكلمة المرور المرفقة $imamPassword للدخول إلى التطبيق, مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك, شكرًا لاستخدامك محراب.',
        [iphone]);

    sending_SMS(
        'تم تأكيد التحاقك بتطبيق محراب, نرجو استخدام رقم الهوية الوطنية وكلمة المرور المرفقة $muathenPassword للدخول إلى التطبيق, مع العلم أنه يجب عليك تغيير كلمة المرور عند دخولك, شكرًا لاستخدامك محراب.',
        [mphone]);
  }

  showAlertDialog2() {
    // set up the buttons

    Widget continueButton = TextButton(
      child: Text("حسنًا", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        if (widget.mnum != '' && widget.mnum != null) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
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
        child: Text("تم إنشاء كل من حساب الإمام والمؤذن بنجاح!",
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

  void _isDuplicate(String text) {
    //Validating
    setState(() {
      _mosquenum.text = text;
    });

    db
        .collection("Account")
        .where('رقم المسجد', isEqualTo: _mosquenum.text)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          DuplicateNum = true;
          DuplicateNumError =
              'تم تعيين وانشاء حسابات الإمام والمؤذن لهذا المسجد مسبقًا';
          showAlertDialog3();

          _IidController.clear();
          _IphoneController.clear();
          _InameController.clear();
          _MidController.clear();
          _MphoneController.clear();
          _MnameController.clear();
        });
      } else {
        setState(() {
          DuplicateNum = false;
        });
        var docRef = db.collection("Mosque").doc(_mosquenum.text);
        var docSnapshot = await docRef.get();

        if (docSnapshot.exists && docSnapshot != null) {
          var data = docSnapshot.data();
          bool isAdded = data!['added'];
          DocumentReference imamRef = data!["Imam"];
          DocumentSnapshot imamDocSnapshot = await imamRef.get();
          DocumentReference muathenRef = data["Muathen"];
          DocumentSnapshot muathenDocSnapshot = await muathenRef.get();
          if (imamDocSnapshot.exists &&
              imamDocSnapshot != null &&
              muathenDocSnapshot.exists &&
              muathenDocSnapshot != null &&
              isAdded) {
            _InameController.text = imamDocSnapshot.get('الاسم');
            _MnameController.text = muathenDocSnapshot.get('الاسم');
            _IphoneController.text = imamDocSnapshot.get('رقم الجوال');
            _MphoneController.text = muathenDocSnapshot.get('رقم الجوال');
            _IidController.text = imamDocSnapshot.id;
            _MidController.text = muathenDocSnapshot.id;
          } else {
            setState(() {
              DuplicateNum = true;
              DuplicateNumError =
                  'المسجد ليس من ضمن المساجد المتوفرة في قاعدة البيانات';
              _IidController.clear();
              _IphoneController.clear();
              _InameController.clear();
              _MidController.clear();
              _MphoneController.clear();
              _MnameController.clear();
            });
          }
        } else {
          setState(() {
            DuplicateNum = true;
            DuplicateNumError =
                'المسجد ليس من ضمن المساجد المتوفرة في قاعدة البيانات';
            _IidController.clear();
            _IphoneController.clear();
            _InameController.clear();
            _MidController.clear();
            _MphoneController.clear();
            _MnameController.clear();
          });
        }
      }
    });
  }

  showAlertDialog3() {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("إلغاء",
          style: TextStyle(fontFamily: 'Elmessiri', color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("تعطيل", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => unauthorized(
                      id: _mosquenum.text,
                    )));
      },
    );
    AlertDialog alert = AlertDialog(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
            "تم تعيين وانشاء حسابات الإمام والمؤذن لهذا المسجد مسبقًا, هل تريد تعطيل واستبدال الحسابات؟",
            style: TextStyle(
              fontFamily: 'Elmessiri',
            )),
      ),
      actions: [cancelButton, continueButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
