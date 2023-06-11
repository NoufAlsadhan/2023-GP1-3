import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mehrab/myMosques.dart';

//import 'package:fluttertoast/fluttertoast.dart';

import 'ItemDetailsScreen.dart';

class Readlistview extends StatefulWidget {
  final String username;

  const Readlistview({required this.username});

  @override
  State<Readlistview> createState() => _ReadlistviewState();
}

class _ReadlistviewState extends State<Readlistview> {
  int _selectedIndex = 3;

  TextEditingController searchController = TextEditingController();

  final db = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> allData = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

  bool loading = false;

  bool _isClicked = false;
//
  List<bool> joinedStatus = [];

  void toggleJoin(QueryDocumentSnapshot<Map<String, dynamic>> document) async {
    final id = document.id;
    if (!myArray.contains(id)) {
      //I joined(the button says leave)
      setState(() {
        myArray.add(id);
      });

      showAlertDialog('إنضمام', document['Name']);

      try {
        await FirebaseFirestore.instance
            .collection('prayer')
            .doc(widget.username)
            .update({
          'joinedMosques': FieldValue.arrayUnion([id])
        });

        await FirebaseFirestore.instance.collection('Mosque').doc(id).update({
          'joinedPrayers': FieldValue.arrayUnion([widget.username])
        });
      } catch (e) {
        print('Error adding item to myArrayField: $e');
      }

      return;
    }

    if (myArray.contains(id)) {
      showAlertDialog('مغادرة', document['Name']);

      //I joined(the button says leave)
      setState(() {
        myArray.remove(id);
      });

      try {
        await FirebaseFirestore.instance
            .collection('prayer')
            .doc(widget.username)
            .update({
          'joinedMosques': FieldValue.arrayRemove([id])
        });

        await FirebaseFirestore.instance.collection('Mosque').doc(id).update({
          'joinedPrayers': FieldValue.arrayRemove([widget.username])
        });

        print('Item removed from myArrayField successfully');
      } catch (e) {
        print('Error removing item from myArrayField: $e');
      }
    }
  }

// nevigate to the itemdetail (coonected with onTap in the list tile)

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsScreen(
          post = post,
        ),
      ),
    );
  }

  List<dynamic> myArray = [];

  Future<void> fetchMosqueFromDataBase() async {
    setState(() {
      loading = true;
    });

    // i will fetch and store data locally in Memory

    try {
      final response =
          await db.collection('Mosque').where('added', isEqualTo: true).get();

      FirebaseFirestore.instance
          .collection('prayer')
          .doc(widget.username)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          myArray = List<dynamic>.from(documentSnapshot['joinedMosques']);

          setState(() {});
        }
      });

      if (response.docs.isNotEmpty) {
        allData = data = response.docs;
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void searchInDatabase(val) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredList = [];

    for (var i in allData) {
      if (i['Name'].contains(val) && !filteredList.contains(i)) {
        filteredList.add(i);
      }

      if (i['District'].contains(val) && !filteredList.contains(i)) {
        filteredList.add(i);
      }

      if (i['Imam name'].contains(val) && !filteredList.contains(i)) {
        filteredList.add(i);
      }

      if (i['Muathen name'].contains(val) && !filteredList.contains(i)) {
        filteredList.add(i);
      }
    }

    setState(() {
      data = filteredList;
    });
  }

  @override
  void initState() {
    fetchMosqueFromDataBase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Create a map to group the elements by district
    // Create a map to group the elements by district
    final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        groupedData = groupBy(data, (element) => element['District']);

// Create a new list that contains the elements grouped by district
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedData = [];

    groupedData.forEach((key, value) {
      // Add the documents for this district to the sortedData list
      sortedData.addAll(value);
    });

    /*List<List<dynamic>> groupByDistrict(List<dynamic> data) {
      final Map<String, List<dynamic>> groupedData = {};

      for (final element in data) {
        final district = element['District'];
        if (!groupedData.containsKey(district)) {
          groupedData[district] = [];
        }
        if (groupedData != null && groupedData[district] != null) {
          groupedData[district]?.add(element);
        }
      }

      return groupedData.values.toList();
    }*/
    /* void toggleJoin(int index, List<dynamic> data) {
      final element = data[index];
      final id = element['id'];
      if (myArray == null) {
        myArray = <int>[];
      }
      if (myArray.contains(id)) {
        myArray.remove(id);
      } else {
        myArray.add(id);
      }
      setState(() {});
    }*/
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
            "قائمة المساجد",
            style: TextStyle(fontFamily: 'Elmessiri'),
          ),
        ),
        automaticallyImplyLeading: false,
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
        items: <BottomNavigationBarItem>[
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
            label: 'مساجدي',
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
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: fetchMosqueFromDataBase,
                child: Column(
                  children: [
                    // Search bar

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
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color.fromARGB(
                                    255, 38, 25, 152), // set the color to blue
                                width: 1.0, // set the thickness of the border
                              ),
                            ),
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: searchController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                hintText: "ابحث ",
                                suffixIcon: const Icon(Icons.search,
                                    color: Color.fromARGB(255, 38, 25, 152)),
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
                        padding: const EdgeInsets.only(top: 1.0),
                        itemCount: sortedData.length,
                        itemBuilder: (context, index) {
                          final item = sortedData[index];
                          //print(item.id);

                          if (item is String) {
                            // Return an empty widget if the item is a string (district name)
                            return SizedBox.shrink();
                          } else {
                            // Build a list item for the element
                            return Card(
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 213, 213, 213),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () {
                                  navigateToDetail(item);
                                },
                                leading: ElevatedButton(
                                  onPressed: () {
                                    toggleJoin(item);
                                  },
                                  child: Text(
                                    myArray.contains(item.id)
                                        ? 'مغادرة'
                                        : 'إنضمام',
                                    style: const TextStyle(
                                      fontFamily: 'Elmessiri',
                                      fontSize: 10,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: myArray.contains(item.id)
                                        ? const Color.fromARGB(255, 38, 25, 152)
                                        : const Color.fromRGBO(212, 175, 55, 1),
                                    minimumSize: const Size(30, 30),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      item['Image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item['Name'],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Elmessiri',
                                  ),
                                ), //Retriveing from the DB
                                subtitle: Text(
                                  'حي ' + item['District'],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Elmessiri',
                                  ),
                                ), //Retriveing from the DB
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  showAlertDialog(String text, String name) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("حسنًا", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    AlertDialog alert;

    if (text == 'مغادرة') {
      alert = AlertDialog(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text('تمت مغادرتك من $name',
              style: TextStyle(fontFamily: 'Elmessiri')),
        ),
        actions: [cancelButton],
      );
    } else {
      alert = AlertDialog(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text('تم إنضمامك لـ$name',
              style: TextStyle(fontFamily: 'Elmessiri')),
        ),
        actions: [cancelButton],
      );
    }

    // show the dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => myMosques(
                  username: widget.username,
                )),
      );
    }
  }
}
