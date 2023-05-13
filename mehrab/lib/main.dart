import 'package:flutter/material.dart';
import 'package:mehrab/managerslogin.dart';
import 'package:mehrab/AdminLogin.dart';
import 'package:mehrab/prayerlogin.dart';
//import 'package:mehrab/Mosquelist.dart';
import 'package:mehrab/Readlistview.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()
  ));
}

class HomePage extends StatelessWidget {
  ///
  const HomePage({super.key});
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.0),
        image: DecorationImage(
          image: AssetImage("images/logo5.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(20, 240, 20, 20),
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'الدخول كـ :',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: 'Elmessiri',
                          fontSize: 20,
                          color: Color.fromARGB(255, 20, 5, 87)),
                    ))),
            Container(
                height: 80,
                width: 280,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    primary: Color.fromARGB(255, 20, 5, 87),
                  ),
                  child: const Text('مصلّـي',
                      style: TextStyle(fontFamily: 'Elmessiri')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const prayerlogin()),
                    );
                  },
                )),
            Container(
                height: 80,
                width: 280,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    primary: Color.fromARGB(255, 20, 5, 87),
                  ),
                  child: const Text('إمام/مـؤذن',
                      style: TextStyle(fontFamily: 'Elmessiri')),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManagersLogin()),
                    );
                  },
                )),
            SizedBox(
              height: 130,
            ),
            Material(
              child: Container(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminLogin()),
                  );
                },
                child: Ink.image(
                  image: AssetImage('images/admin.png'),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
              )),
            ),
          ],
        ),
      ),
    );
    // This widget is the root of your application.
  }
}
