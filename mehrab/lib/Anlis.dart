import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class Anlis extends StatefulWidget {
  final String postID;

  Anlis(this.postID);
  //final String id;

  //const Anlis({Key? key, required this.id}) : super(key: key);

  @override
  State<Anlis> createState() => _AnlisState();
}

class _AnlisState extends State<Anlis> {
  late final Query _query;

  @override
  void initState() {
    super.initState();
    _query = FirebaseFirestore.instance
        .collection('announcement')
        .where('MosqueID', isEqualTo: widget.postID);
    // print(widget.postID);
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
        leading: Container(),
        actions: [
          IconButton(
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(Icons.arrow_back),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        automaticallyImplyLeading:
            false, // this is used the remove the automatic leading
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 38, 25, 152),

//adding the mosque name as a title in the Appbar
        title: Text(
          "المستجدات",
          style: TextStyle(fontFamily: 'Elmessiri'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _query.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("يوجد خطأ"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("لا يوجد مستجدات"),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final mosqueID = doc['MosqueID'];
                print('MosqueID for announcement $index: $mosqueID');

                final date = (doc['Date']);
                final title = doc['Title'];
                final content = doc['Content'];
                final writer = doc['Writer_name'];

                return Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 2, color: Color.fromRGBO(213, 213, 213, 1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //elevation: 9,

                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.person_2_outlined,
                                      color: Color.fromRGBO(212, 175, 55, 1),
                                      size: 30,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            writer,
                                            style: TextStyle(
                                              fontFamily: 'Elmessiri',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 20, 5, 87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                title,
                                style: TextStyle(
                                  fontFamily: 'Elmessiri',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 20, 5, 87),
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 10),
                              Text(
                                content,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Elmessiri',
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 20, 5, 87),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                ' تاريخ الإعلان: ' + date + '\u0647\u0640',
                                style: TextStyle(
                                  fontFamily: 'Elmessiri',
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 20, 5, 87),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
