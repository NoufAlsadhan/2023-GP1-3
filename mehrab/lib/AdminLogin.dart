import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading:  BackButton(
                color: Colors.white,
                onPressed: () { Navigator.pop(context);
                  }
                 // <-- SEE HERE
              ),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تسجيل الدخول للمشرف',
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
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
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
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle,
                                color: Color.fromRGBO(212, 175, 55, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: 'البريد الإلكتروني',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
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
                              color: Color.fromARGB(255, 20, 5, 87),
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
                            primary: Color.fromARGB(255, 20, 5, 87),
                          ),
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(fontFamily: 'Elmessiri')),
                          onPressed: () {},
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
}