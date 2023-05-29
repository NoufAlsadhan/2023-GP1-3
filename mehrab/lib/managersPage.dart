import 'dart:developer'; 
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class ManagersPage extends StatefulWidget {
  final String mosqueId; 
  const ManagersPage({
    super.key,
    required this.mosqueId,//received from managers login page to know what exact mosque to fetch its data
  });

  @override
  _managersPage createState() => _managersPage();
}

class _managersPage extends State<ManagersPage> {
  late String mosqueId = widget.mosqueId; //late to be initialized later
  final db = FirebaseFirestore.instance;

  List<String> _prayer = []; //array to store prayers usernames
  List<Map<String, dynamic>> mosqueMembers = []; //declared like this because it carries different data types
  bool loading = false;

  Future<void> fetchMosque() async {
    setState(() {
      loading = true;
      _prayer.clear(); //clear this array each time we run the code
    });
    try {
      final response = await db.collection('Mosque').doc(mosqueId).get();
      if (response.exists) {
        final data = response.data() as Map<String, dynamic>;

        _prayer = data['joinedPrayers'].cast<String>();
        log("message: $_prayer");
      }
      setState(() {
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      debugPrint('error: $error');
    }
  } //end fetch mosque prayers(joinedPrayers array)

  Future<void> fetchPrayersData() async {
    setState(() {
      loading = true;
      mosqueMembers.clear(); //clear this array each time we run the code to avoid overlapping
    });
    for (var i in _prayer) {
      try {
        final response = await db.collection('prayer').doc(i).get();
        if (response.exists) {
          final data = response.data() as Map<String, dynamic>;

          log("message: $data");
          mosqueMembers.add(data);
        }
        setState(() {
          loading = false;
        });
      } catch (error) {
        setState(() {
          loading = false;
        });
        debugPrint('error: $error');
      }
    }// for loop that brings all prayers data joined that mosque
  } //end fetch each prayer data

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    await fetchMosque().then((_) {
      if (_prayer.isNotEmpty) { //check that array prayers is not empty
        log("members in this mosque");
        fetchPrayersData().then((_) {
          setState(() {});
        });
      } else { //if there are no prayers in that mosque the code will log a text
        log("no members in this mosque");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: const Align(
          child: Text(
            "قائمة المصلين المنضمين إلى مسجدك",
            style: TextStyle(fontFamily: 'Elmessiri'),
          ),
        ),
        automaticallyImplyLeading: false, //backbutton
        backgroundColor: const Color.fromARGB(255, 20, 5, 87),
      ),

      // create the navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque),
            label: 'الإشتراكات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        ],
      ),

      

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),//the loading circle when the page is being refreshed
              )
            : _prayer.isEmpty
                ? RefreshIndicator(
                    onRefresh: () async => fetchData(),
                    child: Stack(children: [
                      const Center(
                        child: Text(
                          "لا يوجد مصلين مسجلين في هذا المسجد", //if array _prayers is empty we will print this msg
                          style: TextStyle(fontFamily: 'Elmessiri')
                        ),
                      ),
                      const SizedBox(height: 20,),
                      ListView(), //else we will call the listView in order to handle the prayers list
                    ]),
                  )
                : mosqueMembers.isEmpty
                    ? RefreshIndicator(
                        onRefresh: () async => fetchData(),
                        child: Stack(children: [
                          const Center(
                            child: Text(
                              "لا يوجد مصلين مسجلين في هذا المسجد",//if array mosqueMembers is empty we will print this msg
                              style: TextStyle(fontFamily: 'Elmessiri')
                            ),
                          ),
                          const SizedBox(height: 20,),
                          ListView(), //else we will call the listView in order to handle the prayers list //there mosque contain prayers
                        ]),
                      )
                    :RefreshIndicator(
                        onRefresh: () async => fetchData(),
                        child: ListView.builder(
                          itemCount: mosqueMembers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 213, 213, 213)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset("images/person.png"),
                                    ),
                                    title: Text(mosqueMembers[index]["الاسم"]),
                                    subtitle: Text(mosqueMembers[index]
                                            ["اسم المستخدم"] +
                                        "@"),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
