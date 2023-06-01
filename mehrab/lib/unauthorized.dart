import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mehrab/AddMosque.dart';
//import 'package:mehrab/AddMosque2.dart';
import 'package:mehrab/AdminLogin.dart';
import 'package:mehrab/createAccounts.dart';
import 'dart:math' as math;
import 'package:mehrab/createUpdatedAccounts.dart';

import 'package:mehrab/managerslogin.dart';

class unauthorized extends StatefulWidget {
  final String id;
  const unauthorized(
      {super.key,
      required this.id //received from managers login page to know what exact mosque to fetch its data
      });

  @override
  _unauthorized createState() => _unauthorized();
}

class _unauthorized extends State<unauthorized> {
  var _selectedOption;
  var _visible = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: Text(
                'تعطيل حساب ',
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'قم باختيار الحسابات التي تود تعطيلها:',
                        style: TextStyle(
                          fontFamily: 'Elmessiri',
                          fontSize: 18,
                          color: Color.fromARGB(255, 20, 5, 87),
                        ),
                      ),
                      SizedBox(height: 20),
                      customRadio('إمام', 'option1'),
                      customRadio('مؤذن', 'option2'),
                      customRadio('كلاهما', 'option3'),
                      Visibility(
                          visible: _visible,
                          child: Text('يجب عليك اختيار أحد الخيارات.',
                              style: TextStyle(color: Colors.red))),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                primary: Color.fromARGB(255, 38, 25, 152),
                              ),
                              child: const Text('تعطيل',
                                  style: TextStyle(fontFamily: 'Elmessiri')),
                              onPressed: () {
                                unauthorizedAcc();
                              }))
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget customRadio(String text, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _selectedOption == value
                ? Color.fromRGBO(212, 175, 55, 1)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: <Widget>[
            Radio(
              value: value,
              groupValue: _selectedOption,
              activeColor: Color.fromARGB(255, 38, 25, 152),
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Elmessiri',
                fontSize: 16,
                color: Color.fromARGB(255, 20, 5, 87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void unauthorizedAcc() async {
    if (_selectedOption == null) {
      setState(() {
        _visible = true;
      });
      return;
    }

    if (_selectedOption != null) {
      setState(() {
        _visible = false;
      });
    }
    final mosqueRef =
        FirebaseFirestore.instance.collection('Mosque').doc(widget.id);
    final mosqueSnapshot = await mosqueRef.get();
    if (_selectedOption == 'option1') {
      final reference = mosqueSnapshot.get('Imam');
      final referencedDocRef = FirebaseFirestore.instance.doc(reference.path);

      final collectionRef = FirebaseFirestore.instance.collection('GG');

      final querySnapshot = await collectionRef
          .where('رقم الهوية', isEqualTo: referencedDocRef.id)
          .get();

      for (QueryDocumentSnapshot queryDocSnapshot in querySnapshot.docs) {
        await queryDocSnapshot.reference.delete();
      }
    }

    if (_selectedOption == 'option2') {
      final reference = mosqueSnapshot.get('Muathen');
      final referencedDocRef = FirebaseFirestore.instance.doc(reference.path);

      final collectionRef = FirebaseFirestore.instance.collection('GG');

      final querySnapshot = await collectionRef
          .where('رقم الهوية', isEqualTo: referencedDocRef.id)
          .get();

      for (QueryDocumentSnapshot queryDocSnapshot in querySnapshot.docs) {
        await queryDocSnapshot.reference.delete();
      }
    } //deactivate muathen

    if (_selectedOption == 'option3') {
      final reference = mosqueSnapshot.get('Imam');
      final referencedDocRef = FirebaseFirestore.instance.doc(reference.path);

      final collectionRef = FirebaseFirestore.instance.collection('Account');

      final querySnapshot = await collectionRef
          .where('رقم الهوية', isEqualTo: referencedDocRef.id)
          .get();

      for (QueryDocumentSnapshot queryDocSnapshot in querySnapshot.docs) {
        await queryDocSnapshot.reference.delete();
      }

      final reference2 = mosqueSnapshot.get('Muathen');
      final referencedDocRef2 = FirebaseFirestore.instance.doc(reference2.path);

      final collectionRef2 = FirebaseFirestore.instance.collection('Account');

      final querySnapshot2 = await collectionRef2
          .where('رقم الهوية', isEqualTo: referencedDocRef2.id)
          .get();

      for (QueryDocumentSnapshot queryDocSnapshot2 in querySnapshot2.docs) {
        await queryDocSnapshot2.reference.delete();
      }
    }
    showAlertDialog3();
    //deactivate both
  }

  showAlertDialog3() {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("حسنًا", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => createUpdatedAccounts(
                  option: _selectedOption, id: widget.id)),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("تعطيل حساب",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
            _selectedOption == 'option3'
                ? 'تم تعطيل الحسابات بنجاح!'
                : "تم تعطيل الحساب بنجاح!",
            style: TextStyle(
              fontFamily: 'Elmessiri',
            )),
      ),
      actions: [
        cancelButton,
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
}
