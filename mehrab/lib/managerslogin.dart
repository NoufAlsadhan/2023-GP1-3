import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final TextEditingController _nationalId = TextEditingController();
final TextEditingController _password = TextEditingController();
bool _visible = false;

class ManagersLogin extends StatefulWidget {
  _managersLogin createState() => _managersLogin();
}

// ignore: camel_case_types
class _managersLogin extends State<ManagersLogin> {
  @override
  void initState() {
    super.initState();
    _nationalId.text = '';
    _password.text = '';
    _visible = false;
  }

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
                  'تسجيل الدخول',
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
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _nationalId,
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
                            labelText: ' رقم الهوية',
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
                        child: TextField(
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
                            labelText: 'كلمة المرور',
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
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(fontFamily: 'Elmessiri')),
                          onPressed: () {
                            if (_nationalId.text.isEmpty ||
                                _password.text.isEmpty) {
                              _toggle();
                            }
                          },
                        )),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'هل نسيت كلمة المرور؟',
                        style: TextStyle(
                            color: Colors.grey[600], fontFamily: 'Elmessiri'),
                      ),
                    ),
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
}
