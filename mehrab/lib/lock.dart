import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mehrab/managersPage.dart';
import 'package:mehrab/managerslogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NukiLockPage extends StatefulWidget {
  final String mosqueId;
  final String id;
  const NukiLockPage(
      {super.key,
      required this.mosqueId,
      required this.id //received from managers login page to know what exact mosque to fetch its data
      });
  @override
  _NukiLockPageState createState() => _NukiLockPageState();
}

class _NukiLockPageState extends State<NukiLockPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LockPage(mosqueId: widget.mosqueId, id: widget.id),
    );
  }
}

class LockPage extends StatefulWidget {
  final String mosqueId;
  final String id;

  const LockPage({required this.mosqueId, required this.id});

  @override
  _LockPageState createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  var accessToken;
  var lockID;
  var _isLocked; // Initial lock state
  int _selectedIndex = 1;
  var hasKey;

  void initState() {
    super.initState();
    checkLock();
  }

  Future<void> _toggleLock() async {
    if (_isLocked == false) {
      var url = 'https://api.nuki.io/smartlock/$lockID/action/lock';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${accessToken}'},
      );

      setState(() {
        _isLocked = !_isLocked;
      });

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Lock')
          .where('Mosque_ID', isEqualTo: widget.mosqueId)
          .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.update({'isLocked': _isLocked});
      }
    } //The door was opened, closing the door
    else {
      var url = 'https://api.nuki.io/smartlock/$lockID/action/unlock';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${accessToken}'},
      );

      setState(() {
        _isLocked = !_isLocked;
      });

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Lock')
          .where('Mosque_ID', isEqualTo: widget.mosqueId)
          .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.update({'isLocked': _isLocked});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'المفتاح',
            style: TextStyle(fontFamily: 'Elmessiri'),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 38, 25, 152),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.black, // <-- This works for fixed
        currentIndex: 1,
        selectedItemColor: Color.fromARGB(255, 38, 25, 152),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'المفتاح',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'المحادثات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
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
          child: InkWell(
              onTap: () {
                _toggleLock();
              },
              child: hasKey == true
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isLocked
                              ? Color.fromARGB(255, 38, 25, 152)
                              : Color.fromRGBO(212, 175, 55, 1),
                          width: 2.0,
                        ),
                        color: _isLocked
                            ? Color.fromARGB(255, 38, 25, 152)
                            : Color.fromRGBO(212, 175, 55, 1),
                      ),
                      width: 200,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: _isLocked
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                            ),
                            child: _isLocked
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: Color.fromARGB(255, 38, 25, 152),
                                        size: 50,
                                      ),
                                      Text(
                                        'مغلق',
                                        style: TextStyle(
                                          fontFamily: 'Elmessiri',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 38, 25, 152),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock_open,
                                        color: Color.fromRGBO(212, 175, 55, 1),
                                        size: 50,
                                      ),
                                      Text(
                                        'مفتوح',
                                        style: TextStyle(
                                          fontFamily: 'Elmessiri',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(212, 175, 55, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  : hasKey == false
                      ? Center(
                          child: const Text(
                            '.لم يتم تفعيل المفتاح',
                            style: TextStyle(
                              fontFamily: 'Elmessiri',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Center(
                          child:
                              CircularProgressIndicator(), //the loading circle when the page is being refreshed
                        )),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ManagersPage(mosqueId: widget.mosqueId, id: widget.id)),
      );
    }
  }

  void checkLock() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Lock')
        .where('Mosque_ID', isEqualTo: widget.mosqueId)
        .get();
    setState(() {
      hasKey = querySnapshot.docs.isNotEmpty;
    });

    if (hasKey == true) {
      final lockDoc = querySnapshot.docs.first;
      setState(() {
        _isLocked = lockDoc['isLocked'];
        accessToken = lockDoc['Token'];
        lockID = querySnapshot.docs.first.id;
        print(_isLocked);
        print(accessToken);
        print(lockID);
      });
    }
  }
}
