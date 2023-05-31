import 'dart:developer';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mehrab/lock.dart';

class ManagersPage extends StatefulWidget {
  final String mosqueId;
  final String id;
  const ManagersPage(
      {super.key,
      required this.mosqueId,
      required this.id //received from managers login page to know what exact mosque to fetch its data
      });

  @override
  _managersPage createState() => _managersPage();
}

class _managersPage extends State<ManagersPage> {
  late String mosqueId = widget.mosqueId; //late to be initialized later
  final db = FirebaseFirestore.instance;
  int _selectedIndex = 3;
  final searchController = TextEditingController();

  final searchFocus = FocusNode();

  List<String> _prayer = []; //array to store prayers usernames
  List<Map<String, dynamic>> mosqueMembers =
      []; //declared like this because it carries different data types
  bool loading = false;
  List<Map<String, dynamic>> allData = [];

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
      mosqueMembers
          .clear(); //clear this array each time we run the code to avoid overlapping
    });
    for (var i in _prayer) {
      try {
        final response = await db.collection('prayer').doc(i).get();
        if (response.exists) {
          final data = response.data() as Map<String, dynamic>;

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
    }
    allData =
        mosqueMembers; // for loop that brings all prayers data joined that mosque
  } //end fetch each prayer data

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    await fetchMosque().then((_) {
      if (_prayer.isNotEmpty) {
        //check that array prayers is not empty

        fetchPrayersData().then((_) {
          setState(() {});
        });
      } else {
        //if there are no prayers in that mosque the code will log a text
      }
    });
  }

  void searchInDatabase(val) async {
    List<Map<String, dynamic>> filteredList = [];

    for (var i in allData) {
      if (("@" + i["اسم المستخدم"]).contains(val)) {
        filteredList.add(i);
      }
    }

    setState(() {
      mosqueMembers = filteredList;
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
          backgroundColor: Color.fromARGB(255, 38, 25, 152),
        ),

        // create the navigation bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3,
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
        body: GestureDetector(
          onTap: () {
            searchFocus.unfocus();
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: loading
                ? const Center(
                    child:
                        CircularProgressIndicator(), //the loading circle when the page is being refreshed
                  )
                : _prayer.isEmpty
                    ? RefreshIndicator(
                        onRefresh: () async => fetchData(),
                        child: Stack(children: [
                          const Center(
                            child: Text(
                                ".لا يوجد مصلين مسجلين في هذا المسجد", //if array _prayers is empty we will print this msg
                                style: TextStyle(
                                    fontFamily: 'Elmessiri',
                                    color: Colors.grey)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListView(), //else we will call the listView in order to handle the prayers list
                        ]),
                      )
                    : mosqueMembers.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async => fetchData(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Color.fromARGB(255, 38, 25,
                                                152), // set the color to blue
                                            width:
                                                1.0, // set the thickness of the border
                                          ),
                                        ),
                                        child: TextFormField(
                                          textDirection: TextDirection.rtl,
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 0),
                                            hintText: "ابحث عن مصلّي",
                                            suffixIcon: const Icon(Icons.search,
                                                color: Color.fromARGB(
                                                    255, 38, 25, 152)),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: searchInDatabase,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Center(
                                    child: Text(
                                      searchFocus.hasFocus
                                          ? "لا توجد نتائج"
                                          : "لا يوجد مصلين مسجلين في هذا المسجد", //if array mosqueMembers is empty we will print this msg

                                      style: const TextStyle(
                                          fontFamily: 'Elmessiri',
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),

                                //else we will call the listView in order to handle the prayers list //there mosque contain prayers
                              ],
                            ))
                        : RefreshIndicator(
                            onRefresh: () async => fetchData(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Color.fromARGB(255, 38, 25,
                                                152), // set the color to blue
                                            width:
                                                1.0, // set the thickness of the border
                                          ),
                                        ),
                                        child: TextFormField(
                                          textDirection: TextDirection.rtl,
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 0),
                                            hintText:
                                                "ابحث عن مسجد, جامع أو حي ",
                                            suffixIcon: const Icon(Icons.search,
                                                color: Color.fromARGB(
                                                    255, 38, 25, 152)),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: searchInDatabase,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
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
                                                  color: Color.fromARGB(
                                                      255, 213, 213, 213)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.asset(
                                                      "images/person.png")

                                                  // child: Image.asset("images/person.png"),

                                                  ),
                                              title: Text(mosqueMembers[index]
                                                  ["الاسم"]),
                                              subtitle: Text(
                                                  mosqueMembers[index]
                                                          ["اسم المستخدم"] +
                                                      "@"),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NukiLockPage(mosqueId: mosqueId, id: widget.id)),
      );
    }
  }
}
