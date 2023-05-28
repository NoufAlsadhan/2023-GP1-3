import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mehrab/ItemDetailsScreen.dart';
import 'package:mehrab/Readlistview.dart';

class myMosques extends StatefulWidget {
  final String username;
  const myMosques({required this.username});

  @override
  State<myMosques> createState() => _myMosquesState();
}

class _myMosquesState extends State<myMosques> {
  int _selectedIndex = 2;
  final _mosque = FirebaseFirestore.instance.collection('Mosque').snapshots();
  final db = FirebaseFirestore.instance;
  var id;
  bool _isClicked = false;
  List<bool> joinedStatus = [];

  void toggleJoin(
      int index, List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    if (!myArray.contains(docs[index].id)) {
      //I joined(the button says leave)
      myArray.add(docs[index].id);
      showAlertDialog('إنضمام', docs[index]['Name']);
      try {
        await FirebaseFirestore.instance
            .collection('prayer')
            .doc(widget.username)
            .update({
          'joinedMosques': FieldValue.arrayUnion([docs[index].id])
        });

        await FirebaseFirestore.instance
            .collection('Mosque')
            .doc(docs[index].id)
            .update({
          'joinedPrayers': FieldValue.arrayUnion([widget.username])
        });
        print('Item added to myArrayField successfully');

        print('Item added to myArrayField successfully');
      } catch (e) {
        print('Error adding item to myArrayField: $e');
      }

      return;
    }

    if (myArray.contains(docs[index].id)) {
      showAlertDialog('مغادرة', docs[index]['Name']);
      //I joined(the button says leave)
      myArray.remove(docs[index].id);
      try {
        await FirebaseFirestore.instance
            .collection('prayer')
            .doc(widget.username)
            .update({
          'joinedMosques': FieldValue.arrayRemove([docs[index].id])
        });

        await FirebaseFirestore.instance
            .collection('Mosque')
            .doc(docs[index].id)
            .update({
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
                )));
  }

  List<dynamic> myArray = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: Align(
          child: Text(
            "مساجدي",
            style: TextStyle(fontFamily: 'Elmessiri'),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 38, 25, 152),
      ),

      // create the navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
            stream: _mosque,
            builder: (context, snapshot) {
              FirebaseFirestore.instance
                  .collection('prayer')
                  .doc(widget.username)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  myArray =
                      List<dynamic>.from(documentSnapshot['joinedMosques']);
                  setState(() {});
                }
              });
              if (snapshot.hasError) {
                return Center(
                  child: const Text(
                    'مشكلة بالاتصال',
                    style: TextStyle(
                      fontFamily: 'Elmessiri',
                      fontSize: 18,
                      color: Color.fromARGB(255, 20, 5, 87),
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const Text(
                    '...جاري التحميل',
                    style: TextStyle(
                      fontFamily: 'Elmessiri',
                      fontSize: 18,
                      color: Color.fromARGB(255, 20, 5, 87),
                    ),
                  ),
                );
              }

              if (snapshot.data == null || myArray.isEmpty) {
                return Center(
                  child: const Text(
                    '.لم تنضم إلى أي مسجد',
                    style: TextStyle(
                      fontFamily: 'Elmessiri',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              //Retrive the documents
              var docs = snapshot.data!.docs;
              //Filtering only jouned mosques
              var filteredDocuments =
                  docs.where((doc) => myArray.contains(doc.id)).toList();

              //start bulidng the list
              return ListView.builder(
                  padding: EdgeInsets.only(top: 20.0),
                  itemCount: filteredDocuments
                      .length, // to stop the list on the DB document length
                  itemBuilder: (context, index) {
                    //list tile is the list item which contain image , mosque name and district name retrived from the DB
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 213, 213, 213)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        //To naviagte to itemdetail UI
                        onTap: () {
                          navigateToDetail(filteredDocuments[index]);
                        },
                        leading: ElevatedButton(
                          onPressed: () {
                            toggleJoin(index, filteredDocuments);
                          },
                          child: Text(
                            myArray.contains(filteredDocuments[index].id)
                                ? 'مغادرة'
                                : 'إنضمام',
                            style: TextStyle(
                                fontFamily: 'Elmessiri', fontSize: 10),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: myArray
                                    .contains(filteredDocuments[index].id)
                                ? Color.fromARGB(255, 38, 25,
                                    152) // set the button color to red if the text is 'مغادرة'
                                : Color.fromRGBO(212, 175, 55, 1),
                            minimumSize: Size(30, 30),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),

                        trailing: Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              filteredDocuments[index]
                                  ['Image'], //Retriveing from the DB
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        title: Text(
                          filteredDocuments[index]['Name'],
                          textAlign: TextAlign.right,
                          style: TextStyle(fontFamily: 'Elmessiri'),
                        ), //Retriveing from the DB
                        subtitle: Text(
                          'حي ' + filteredDocuments[index]['District'],
                          textAlign: TextAlign.right,
                          style: TextStyle(fontFamily: 'Elmessiri'),
                        ), //Retriveing from the DB
                      ),
                    );
                  });
            }),
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

    if (_selectedIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Readlistview(
                  username: widget.username,
                )),
      );
    }
  }
}
