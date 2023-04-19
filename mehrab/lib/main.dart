import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  ///
  const HomePage({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
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
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
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
                    onPressed: () {},
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
                    onPressed: () {},
                  )),
            ],
          ),
        ),
      ),
    );
    // This widget is the root of your application.
  }
}
