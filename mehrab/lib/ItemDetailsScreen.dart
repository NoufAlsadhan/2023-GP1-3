import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mehrab/Anlis.dart';
import 'dart:math' as math;
import 'dart:math';

class ItemDetailsScreen extends StatefulWidget {
  final DocumentSnapshot post;

  ItemDetailsScreen(this.post);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final announcement =
      FirebaseFirestore.instance.collection('announcement').snapshots();

  final db2 = FirebaseFirestore.instance;

//var id = post.id;
  _launchURL() async {
    Uri _url = Uri.parse(widget.post['Location']);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  //@override
  /*void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }*/

  /* void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      setState(() {
        _showLastItem = true;
      });
    }
  }*/

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      setState(() {
        _showLastItem = true;
      });
    } else if (_showLastItem) {
      // Add this else-if block to hide the widget when scrolling back up
      setState(() {
        _showLastItem = false;
      });
    }
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Colors.pink),
      ),
    );
  }
  /*void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      _showLastItem = true;
      // Get the position of the last item
      final RenderBox renderBox =
      context.findRenderObject() as RenderBox;
      //final lastItemIndex = 5- 1;
      final lastItemPosition =
      renderBox.localToGlobal(renderBox.size.bottomLeft(Offset.zero));

      // Check if the last item is visible
      if (lastItemPosition.dy < MediaQuery.of(context).size.height) {
       // _showLastItem = false;
        _showLastItem = true;
        // Load more items
      }
    }
  }*/

  bool _showLastItem = false;
  @override
  Widget build(BuildContext context) {
    var id = widget.post.id;
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
          widget.post['Name'],
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
                              widget.post['Image'],
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
                                  child: Text(
                                      'الحي: ${widget.post['District']}',
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
                                  child: Text(
                                      'الإمام: ${widget.post['Imam name']}',
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
                                  child: Text(
                                      'المؤذن: ${widget.post['Muathen name']}',
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

                                  int numDocs = 0;
                                  if (snapshot.hasData) {
                                    numDocs = docs.length;
                                  }

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
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: SafeArea(
                                              child: LayoutBuilder(
                                                builder: (BuildContext context,
                                                    BoxConstraints
                                                        constraints) {
                                                  int numItems =
                                                      min(5, numDocs);

                                                  return Container(
                                                    height: 200,
                                                    width: 350,
                                                    child: ListView.builder(
                                                      controller:
                                                          _scrollController,
                                                      // bool _isScrolledToEnd = false;

                                                      //itemCount: snapshot.data!.docs.length,
                                                      itemCount: numItems,

                                                      scrollDirection:
                                                          Axis.horizontal,

                                                      itemBuilder:
                                                          (context, index) =>
                                                              Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      213,
                                                                      213,
                                                                      213)),
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        height: 120,
                                                        width: 300,
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .person_2_outlined,
                                                                      color: Color.fromRGBO(
                                                                          212,
                                                                          175,
                                                                          55,
                                                                          1),
                                                                      size: 30,
                                                                    ),

                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    // add a small space between the icon and text
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '${snapshot.data!.docs[index]['Writer_name']}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Elmessiri',
                                                                              fontSize: 15,
                                                                              color: Color.fromARGB(255, 20, 5, 87),
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
                                                                        child:
                                                                            Text(
                                                                          '${snapshot.data!.docs[index]['Title']}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Elmessiri',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                15,
                                                                            color: Color.fromARGB(
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
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topCenter,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          '\n${snapshot.data!.docs[index]['Content']}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Elmessiri',
                                                                            fontSize:
                                                                                14,
                                                                            // reduce font size
                                                                            color: Color.fromARGB(
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
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Text(
                                                                        '\n\n تاريخ الإعلان: ${snapshot.data!.docs[index]['Date']} \u0647\u0640',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Elmessiri',
                                                                          fontSize:
                                                                              12,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              20,
                                                                              5,
                                                                              87),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
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
                                          ),
                                          if (numDocs >= 5 && _showLastItem)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Anlis(id)),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 2,
                                                            color:
                                                                Color.fromARGB(
                                                                    0,
                                                                    213,
                                                                    213,
                                                                    213)),
                                                        bottom: BorderSide(
                                                            width: 2,
                                                            color:
                                                                Color.fromARGB(
                                                                    0,
                                                                    213,
                                                                    213,
                                                                    213)),
                                                        left: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Color.fromARGB(
                                                                    0,
                                                                    213,
                                                                    213,
                                                                    213)),
                                                        right: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Color.fromARGB(
                                                                    0,
                                                                    213,
                                                                    213,
                                                                    213)),
                                                      ),
                                                    ),
                                                    //  padding: EdgeInsets.only(right:5 , left:5),
                                                    child: Text(
                                                      '\n\n\n\n\n\n\nعرض المزيد..',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Elmessiri',
                                                        fontSize: 13,
                                                        color: Color.fromARGB(
                                                            255, 37, 171, 238),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
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
