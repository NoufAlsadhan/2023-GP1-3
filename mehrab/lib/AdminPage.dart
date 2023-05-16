import 'package:flutter/material.dart';
import 'package:mehrab/AddMosque.dart';
//import 'package:mehrab/AddMosque2.dart';
import 'package:mehrab/AdminLogin.dart';
import 'package:mehrab/createAccounts.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key, required id});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 20, 5, 87),
              automaticallyImplyLeading: false,
              title: Align(
                alignment: Alignment.center,
                child: Text('الرئيسية ',
                    style: TextStyle(fontFamily: 'Elmessiri')),
              ),
              centerTitle: true,
              //backgroundColor: Color.fromARGB(255, 20, 5, 87),
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
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                      child: Image.asset(
                        'images/logo4.png',
                        height: 200,
                        width: 230,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 80,
                        width: 300,
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //minimumSize: const Size.fromHeight(50),
                            primary: Color.fromARGB(255, 20, 5, 87),
                          ),
                          child: const Text(' إضافة مسجد',
                              style: TextStyle(
                                  fontFamily: 'Elmessiri', fontSize: 20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMosque()),
                            );
                          },
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 80,
                        width: 300,
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //minimumSize: const Size.fromHeight(50),
                            primary: Color.fromARGB(255, 20, 5, 87),
                          ),
                          child: const Text(' إنشاء حسابات المؤذن و الإمام',
                              style: TextStyle(
                                  fontFamily: 'Elmessiri', fontSize: 20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => createAccounts()),
                            );
                          },
                        )),
                  ],
                ),
              ),
            )));
  }
}
