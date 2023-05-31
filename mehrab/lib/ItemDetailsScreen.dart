import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ItemDetailsScreen extends StatelessWidget {
  final DocumentSnapshot post;
  final announcement =
      FirebaseFirestore.instance.collection('announcement').snapshots();
  final db2 = FirebaseFirestore.instance;

//to show the Item detail screen for the selected list tile (list item)
  ItemDetailsScreen(this.post);

//var id = post.id;
  // create the location url and retreving the location from the DB
  _launchURL() async {
    Uri _url = Uri.parse(post['Location']);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var id = post.id;
    print(id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          post['Name'],
          style: TextStyle(fontFamily: 'Elmessiri'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: 450,
                          height: 250,
                          //Adding the images retrived from the DB
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              post['Image'],
                              alignment: Alignment.center,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        /*create column of rows , column for التفاصيل text and the rows for the 
                        district name , google maps location and mosque managers names  */
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'التفاصيل ',
                              style: new TextStyle(
                                fontFamily: 'Elmessiri',
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                color: Color.fromARGB(255, 20, 5, 87),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('الحي: ${post['District']}',
                                      textAlign: TextAlign.right,
                                      style: new TextStyle(
                                        fontFamily: 'Elmessiri',
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 20, 5, 87),
                                      )),
                                ),
                                Icon(
                                  Icons.location_city_rounded,
                                  color: Color.fromRGBO(212, 175, 55, 1),
                                  size: 40,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  //open location with google maps
                                  child: InkWell(
                                    onTap: _launchURL,
                                    child: const Text(
                                      'افتح مع خارطة جوجل',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'Elmessiri',
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 37, 171, 238),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.pin_drop_outlined,
                                  color: Color.fromRGBO(212, 175, 55, 1),
                                  size: 40,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('الإمام: ${post['Imam name']}',
                                      textAlign: TextAlign.right,
                                      style: new TextStyle(
                                          fontFamily: 'Elmessiri',
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 20, 5, 87))),
                                ),
                                Icon(
                                  Icons.person_2_outlined,
                                  color: Color.fromRGBO(212, 175, 55, 1),
                                  size: 40,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text('المؤذن: ${post['Muathen name']}',
                                      textAlign: TextAlign.right,
                                      style: new TextStyle(
                                          fontFamily: 'Elmessiri',
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 20, 5, 87))),
                                ),
                                Icon(
                                  Icons.person_2_outlined,
                                  color: Color.fromRGBO(212, 175, 55, 1),
                                  size: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                        //create column for the announcements
                        Column(
                          children: const [
                            Divider(
                              color: Color.fromARGB(255, 166, 165, 167),
                            ),
                            Text(
                              'المستجدات',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 20, 5, 87),
                                fontFamily: 'Elmessiri',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: db2
                                    .collection('announcement')
                                    .where('MosqueID', isEqualTo: id)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: const Text(
                                        'جاري التحميل',
                                        style: TextStyle(
                                          fontFamily: 'Elmessiri',
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 20, 5, 87),
                                        ),
                                      ),
                                    );
                                  }

                                  List<DocumentSnapshot> docs =
                                      snapshot.data!.docs;

                                  if (docs.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'لا يوجد مستجدات حالية',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 166, 165, 167),
                                          fontFamily: 'Elmessiri',
                                        ),
                                      ),
                                    );
                                  }

                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 2,
                                              color: Color.fromARGB(
                                                  255, 213, 213, 213)),
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        margin: EdgeInsets.all(10),
                                        height: 120,
                                        width: 300,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                            Positioned(
                                              left: -10,
                                              top: -10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(
                                                      212, 175, 55, 1),
                                                ),
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person_2_outlined,
                                                      color: Color.fromRGBO(
                                                          212, 175, 55, 1),
                                                      size: 30,
                                                    ),

                                                    SizedBox(
                                                        width:
                                                            5), // add a small space between the icon and text
                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${snapshot.data!.docs[index]['Writer_name']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Elmessiri',
                                                              fontSize: 15,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      20,
                                                                      5,
                                                                      87),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          '${snapshot.data!.docs[index]['Title']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Elmessiri',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    20,
                                                                    5,
                                                                    87),
                                                          ),
                                                        ),
                                                      ),

                                                      /*Icon(
                            Icons.notifications_none_outlined,
                            color: Color.fromRGBO(212, 175, 55, 1),
                            size: 27,
                          ),*/
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                        child: Text(
                                                          '\n${snapshot.data!.docs[index]['Content']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Elmessiri',
                                                            fontSize:
                                                                14, // reduce font size
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    20,
                                                                    5,
                                                                    87),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      child: Text(
                                                        '\n\n\n تاريخ الإعلان: ${snapshot.data!.docs[index]['Date']} \u0647\u0640',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Elmessiri',
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255, 20, 5, 87),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )

/*StreamBuilder<QuerySnapshot>(
                              stream: announcement,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                    'خطأ في الاتصال بقاعدة البيانات',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontFamily: 'Elmessiri',
                                    ),
                                  );
                                }

                                if (!snapshot.hasData) {
                                  return Text(
                                    'لا يوجد بيانات',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Elmessiri',
                                    ),
                                  );
                                }

                                List<DocumentSnapshot> docs =
                                    snapshot.data.docs;

                                if (docs.isEmpty) {
                                  return Text(
                                    'لا يوجد مستجدات حالية',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(
                                          255, 166, 165, 167),
                                      fontFamily: 'Elmessiri',
                                    ),
                                  );
                                }
                                  }
)*/
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
