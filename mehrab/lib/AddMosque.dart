import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mehrab/AdminLogin.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:mehrab/AddMosque.dart';
import 'dart:async';
//import 'dart:math';
import 'dart:developer' as dev;
import 'dart:math' as math;

final _formKey = GlobalKey<FormState>();
final _controller = TextEditingController();
final TextEditingController _Mosquenum = TextEditingController();
final TextEditingController _MosqueNameController = TextEditingController();
final TextEditingController _District = TextEditingController();
final TextEditingController _LocLink = TextEditingController();
final TextEditingController imageUrl = TextEditingController();
final TextEditingController _ImamName = TextEditingController();
final TextEditingController _MuathenName = TextEditingController();
final TextEditingController _MosqueImage = TextEditingController();
var db = FirebaseFirestore.instance;

List<String> itemsList = ['خالد', 'محمد', 'عاصم', 'صالح', 'عبدالله'];
String? selectedItem = 'خالد';

class AddMosque extends StatefulWidget {
  _AddMosqueState createState() => _AddMosqueState();
}

class _AddMosqueState extends State<AddMosque> {
  final _controller = TextEditingController();

  void initState() {
    super.initState();
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Mosque');
    late Stream<QuerySnapshot> _stream;
    _stream = collectionRef.snapshots();
    _Mosquenum.text = '';
    _MosqueNameController.text = '';
    _District.text = '';
    _LocLink.text = '';
    _ImamName.text = '';
    _MuathenName.text = '';
    _MosqueImage.text = '';
    imageUrl.text = '';
  }

  bool _visible = false;
  var _isAdded;
  bool _visible2 = false;
  var numberErrorMessageI = '';
  var ImageErrorMessage = '';
  var UrlErrorMessage = '';
  var MosqueNameErrorMessage = '';
  var validNum = true;
  var validUrl = true;
  var validMname = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = false;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mehrab',
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
                'إضافة مسجد جديد',
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
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: _Mosquenum,
                              onFieldSubmitted: _isDuplicate,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText: validNum == false
                                    ? numberErrorMessageI
                                    : null,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 20, 5, 87),
                                      width: 1),
                                ),
                                labelText: '   *رقم المسجد',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Elmessiri",
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ), //Mosque number container

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _MosqueNameController,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 20, 5, 87),
                                      width: 1),
                                ),
                                labelText: '   اسم المسجد',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Elmessiri",
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ), //Mosque name container

                        // const SizedBox(height: 20,),

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _District,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 20, 5, 87),
                                      width: 1),
                                ),
                                labelText: '   الحي ',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Elmessiri",
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),

                        /* Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        decoration:  BoxDecoration(
                                   borderRadius: BorderRadius.circular(90.0),
                                   //border: Border.all(color:Color.fromARGB(255, 20, 5, 87), width: 1),
                                ), 
                       // width: 370,
                        //height: 60, 
                      //padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration( 
                            labelText: 'اختر  الحي',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                          ),
                          iconSize: 25,
                          icon: Icon(Icons.arrow_drop_down_circle, color:  Color.fromARGB(255, 38, 25, 152),),
                              borderRadius: BorderRadius.circular(20), // هذا الراديس حق الخيارات
                                value: selectedItem,
                                items: itemsList
                                .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: TextStyle(fontSize: 15))))
                                  .toList(),
                                  onChanged: (item) => setState(() => selectedItem = item)
                                  ),
                                  ),
                                  ), */

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _ImamName,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
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
                        ), //Imam name container

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _MuathenName,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
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
                        ), //Muathen name controller

                        /* const SizedBox(
                          height: 20,
                        ), */

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: imageUrl,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 20, 5, 87),
                                      width: 1),
                                ),
                                labelText: '   رابط صورة المسجد ',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Elmessiri",
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ), // Image container

                        /*Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              ' *أضف صورة المسجد :',
                              style: TextStyle(
                                  fontFamily: 'Elmessiri', fontSize: 12),
                            ),
                          ),
                        ),*/
                        /*  Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: IconButton(
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? file = await imagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  print('${file?.path}');

                                  if (file == null) return;

                                  String uniqueFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceDirImages =
                                      referenceRoot.child('images');
                                  Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);

                                  try {
                                    await referenceImageToUpload
                                        .putFile(File(file!.path));
                                    setState(() async {
                                      imageUrl = await referenceImageToUpload
                                          .getDownloadURL();
                                      print(imageUrl);

                                      if (imageUrl.isNotEmpty == true) {
                                        _toggle2();
                                      }
                                    });
                                  } catch (error) {
                                    //some error
                                  }
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Color.fromARGB(255, 20, 5, 87),
                                )),
                          ),
                        ),*/ //adding mosque image container

                        Visibility(
                            visible: _visible2,
                            child: Text('تم إدراج صورة المسجد بنجاح',
                                style: TextStyle(color: Colors.green))),
                        //feedback after adding image successfully

                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              enabled: false,
                              controller: _LocLink,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 20, 5, 87),
                                      width: 1),
                                ),
                                labelText: '   رابط الموقع ',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Elmessiri",
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ), //URL container

                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                            visible: _visible,
                            child: Text(' جميع الحقول مطلوبة ',
                                style: TextStyle(color: Colors.red))),
                        //feedback of filling all fields

                        Container(
                            height: 80,
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  primary: Color.fromARGB(255, 38, 25, 152),
                                ),
                                child: const Text('إضافة المسجد',
                                    style: TextStyle(fontFamily: 'Elmessiri')),
                                onPressed: () async {
                                  bool empt = false;
                                  bool falselength = false;
                                  if (_Mosquenum.text.isEmpty ||
                                      _MosqueNameController.text.isEmpty ||
                                      _District.text.isEmpty ||
                                      _LocLink.text.isEmpty ||
                                      _ImamName.text.isEmpty ||
                                      _MuathenName.text.isEmpty ||
                                      imageUrl.text.isEmpty ||
                                      _Mosquenum.text == '' ||
                                      _MosqueNameController.text == '' ||
                                      _District.text == '' ||
                                      _LocLink.text == '' ||
                                      _ImamName.text == '' ||
                                      _MuathenName.text == '' ||
                                      imageUrl == '') {
                                    empt = true;
                                    _toggle();
                                  }

                                  if (_Mosquenum.text.isNotEmpty &&
                                      _MosqueNameController.text.isNotEmpty &&
                                      _District.text.isNotEmpty &&
                                      _LocLink.text.isNotEmpty &&
                                      _ImamName.text.isNotEmpty &&
                                      _MuathenName.text.isNotEmpty &&
                                      imageUrl.text.isNotEmpty &&
                                      _Mosquenum.text != '' &&
                                      _MosqueNameController.text != '' &&
                                      _District.text != '' &&
                                      _LocLink.text != '' &&
                                      _ImamName.text != '' &&
                                      _MuathenName.text != '' &&
                                      imageUrl != '') {
                                    empt = false;
                                    _toggle1();
                                  }

                                  if (_Mosquenum.text.length != 4) {
                                    falselength = true;
                                  }

                                  if (empt == false &&
                                      falselength == false &&
                                      validNum == true) {
                                    final MosqueData = {
                                      "Name": _MosqueNameController.text,
                                      "District": _District.text,
                                      "Location": _LocLink.text,
                                      "Imam name": _ImamName.text,
                                      "Muathen name": _MuathenName.text,
                                      "Image": imageUrl,
                                    };

                                    var uri = Uri.parse(_LocLink.text);
                                    print(uri);
                                    showAlertDialog(context, MosqueData);
                                  }
                                  setState(() {});
                                })), //end of add button
                      ],
                    ),
                  ),
                )))));
  }

  void _toggle() {
    setState(() {
      _visible = true;
    });
  } //check empty fields

  void _toggle1() {
    setState(() {
      _visible = false;
    });
  } //check non empty fields

  void _toggle2() {
    setState(() {
      _visible2 = true;
    });
  } //check the url

  validateUrl(String text) async {
    var v = true;

    if (!text.startsWith('https://goo.gl/maps')) {
      setState(() {
        validUrl = false;
        UrlErrorMessage =
            'يجب أن تبدأ صيغة الرابط بـ (.......https://goo.gl/maps)';
        v = false;
      });
    } else if (text.startsWith('https://goo.gl/maps')) {
      setState(() {
        validUrl = true;
      });
    }
  } //End validate URL

  validateMosqueName(String text) async {
    var v = true;

    if (!(text.startsWith('مسجد')) || (!text.startsWith('جامع'))) {
      setState(() {
        validMname = false;
        MosqueNameErrorMessage = 'يجب أن يبدأ الاسم بـ : جامع أو مسجد';
        v = false;
      });
    }
    if ((text.startsWith('مسجد')) || text.startsWith('جامع')) {
      setState(() {
        print('hello');
        validMname = true;
      });
    }
  } //End validate Mosque Name

  validateNum(String text) async {
    var v = true;
    if (!(text.length == 4) && text.isNotEmpty) {
      setState(() {
        validNum = false;
        numberErrorMessageI = 'رقم المسجد يجب   أن يتكون من 4 أرقام فقط';
        v = false;
      });
    } else {
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection('Mosque').doc(text);
      DocumentSnapshot snapshot = await documentRef.get();
      if (snapshot.exists) {
        setState(() {
          validNum = false;
          numberErrorMessageI = "رقم المسجد مسجَّل مسبقًا";
          v = false;
        });

        String documentId = snapshot.id;
        print('Document ID: $documentId');
      } else {
        print('Document does not exist');
      }

      db.collection("Mosque").doc(text).get().then((querySnapshot) {});

      if (v == true) {
        setState(() {
          validNum = true;
        });
      }
    }
  } //validating mosque number

  showAlertDialog(
    BuildContext context,
    Map<String, Object> MosqueData,
  ) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء",
          style: TextStyle(fontFamily: 'Elmessiri', color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("إضافة", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        //Add(MosqueData);
        Navigator.pop(context);

        //_Mosquenum.clear();
        _MosqueNameController.clear();
        _District.clear();
        _LocLink.clear();
        _ImamName.clear();
        _MuathenName.clear();
        imageUrl.clear();

        Add();
        _Mosquenum.clear();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(" إضافة مسجد",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("هل أنت متأكد من المعلومات المعطاة لإضافة المسجد ؟",
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
  } //confirmation msg after validating all input and clicking add button

  void Add() {
    print("lama");
    db
        .collection('Mosque')
        .doc(_Mosquenum.text)
        .update({
          'added': true,
        })
        .then((value) => print('Document updated successfully!'))
        .catchError((error) => print('Error updating document: $error'));
  }

  Future<void> _isDuplicate(String text) async {
    //Validating
    var docRef = db.collection("Mosque").doc(text);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      var data = docSnapshot.data();

      if (data!["added"]) {
        setState(() {
          validNum = false;
          numberErrorMessageI = 'هذا المسجد مضاف مسبقًا';

          _MosqueNameController.clear();
          _District.clear();
          _LocLink.clear();
          _ImamName.clear();
          _MuathenName.clear();
          imageUrl.clear();
        });
      } else {
        //هنا الكود حق الاوتوفل
        setState(() {
          validNum = true;
        });
        var docRef = db.collection("Mosque").doc(text);
        var docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data();
          _MosqueNameController.text = data!["Name"];
          _District.text = data!["District"];
          _ImamName.text = data!["Imam name"];
          _MuathenName.text = data!["Muathen name"];
          imageUrl.text = data?["Image"];
          _LocLink.text = data?["Location"];
        }
      }
      //final lockDoc = querySnapshot.docs.first;
    } else {
      setState(() {
        validNum = false;
        numberErrorMessageI = 'هذا المسجد  ليس موجود في قاعدة البيانات';
        _MosqueNameController.clear();
        _District.clear();
        _LocLink.clear();
        _ImamName.clear();
        _MuathenName.clear();
        imageUrl.clear();
      });
    }
  }
} //adding the mosque data to Mehrab database
