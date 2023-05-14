import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehrab/prayerlogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

var db = FirebaseFirestore.instance;

class managersPage extends StatefulWidget {
  final String id;
  const managersPage({required this.id});

  _managersPage createState() => _managersPage();
}

class _managersPage extends State<managersPage> {
  late bool _showDialog;

  @override
  Widget build(BuildContext context) {
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
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الرئيسية ',
                style: TextStyle(fontFamily: 'Elmessiri'),
              ),
            ),
            leading: Container(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.key,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Perform the search here
                    },
                  ),
                ),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 20, 5, 87),
          ),
          bottomNavigationBar: BottomNavigationBar(
            //backgroundColor: Colors.black, // <-- This works for fixed
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'الملف الشخصي',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'المحادثات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.blue),
                label: 'الرئيسية',
              ),
            ],
          ),
        ));
  }
}
