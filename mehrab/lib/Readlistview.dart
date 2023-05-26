import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mehrab/ItemDetailsScreen.dart';

class Readlistview extends StatefulWidget {
  final String username;
  const Readlistview({required this.username});

  @override
  State<Readlistview> createState() => _ReadlistviewState();
}

class _ReadlistviewState extends State<Readlistview> {
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

              if (snapshot.data == null) {
                return Center(
                  child: const Text(
                    'لا يوجد معلومات',
                    style: TextStyle(
                      fontFamily: 'Elmessiri',
                      fontSize: 18,
                      color: Color.fromARGB(255, 20, 5, 87),
                    ),
                  ),
                );
              }

              //Retrive the documents
              var docs = snapshot.data!.docs;

              //start bulidng the list
              return ListView.builder(
                  padding: EdgeInsets.only(top: 20.0),
                  itemCount:
                      docs.length, // to stop the list on the DB document length
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
                          navigateToDetail(docs[index]);
                        },
                        leading: ElevatedButton(
                          onPressed: () {
                            toggleJoin(index, docs);
                          },
                          child: Text(
                            myArray.contains(docs[index].id)
                                ? 'مغادرة'
                                : 'إنضمام',
                            style: TextStyle(
                                fontFamily: 'Elmessiri', fontSize: 10),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: myArray.contains(docs[index].id)
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
                              docs[index]['Image'], //Retriveing from the DB
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        title: Text(
                          docs[index]['Name'],
                          textAlign: TextAlign.right,
                          style: TextStyle(fontFamily: 'Elmessiri'),
                        ), //Retriveing from the DB
                        subtitle: Text(
                          'حي ' + docs[index]['District'],
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
        Navigator.of(context).popUntil((route) => route.isFirst);
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
}
