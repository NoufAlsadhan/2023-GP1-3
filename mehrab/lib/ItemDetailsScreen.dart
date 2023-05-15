import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatelessWidget {
  final DocumentSnapshot post;

  ItemDetailsScreen(this.post);

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: BackButton(color: Colors.white),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 20, 5, 87),
          title: Text(
            post['Name'],
            style: TextStyle(fontFamily: 'Elmessiri'),
          ),
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
              icon: Icon(Icons.notifications),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mosque),
              label: 'الإشتراكات',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ), //color: Colors.blue),
              label: 'الرئيسية',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                //alignment: Alignment.topRight,
                children: [
                  Expanded(
                    child: Column(
                      ///////////////////
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: 450,
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              post['Image'],
                              alignment: Alignment.center,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
Column(crossAxisAlignment: CrossAxisAlignment.center ,
  children: [
  
   //Align(
   //alignment:Alignment.centerRight,
   /* child:*/Text('التفاصيل ', style: new TextStyle(
                                    fontFamily: 'Elmessiri',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                    color: Color.fromARGB(255, 20, 5, 87),
                                     ),),

   //),



 
  Row(
     // crossAxisAlignment: CrossAxisAlignment.end ,
      children: [
  
          Expanded(
            child: Text('الحي: ${post['District']}',textAlign: TextAlign.right,
                                    style: new TextStyle(
                                        fontFamily: 'Elmessiri',
                                       // fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 20, 5, 87),
                                        
                                         )),
          ),
                                          Icon(
                                Icons.location_city_rounded ,
                                color: Color.fromRGBO(212, 175, 55, 1),
                                size: 40 ,
                              ),
  
      ],),
 
   
   
    Row(
      children: [

          Expanded(
            child: InkWell(
                                onTap: _launchURL,
                                child: const Text(
                                  'افتح مع خارطة جوجل',textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Elmessiri',
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 37, 171, 238),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
          ),
                            Icon(
                              Icons.pin_drop_outlined ,
                              color: Color.fromRGBO(212, 175, 55, 1),
                              size:40,
                            )
      ],
    ),




    Row(children: [

                            Expanded(
                              child: Text('الإمام: ${post['Imam name']}',textAlign: TextAlign.right,
                                    style: new TextStyle(
                                        fontFamily: 'Elmessiri',
                                       // fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 20, 5, 87)
                                        )
                                        ),
                            ),
                            
                            // tooltip: 'Increase volume by 10',
                            //),
                            Icon(
                              Icons.person_2_outlined,
                              color:  Color.fromRGBO(212, 175, 55, 1),
                              size: 40 ,

                             
                            ),
      
    ],),
                        


Row(children: [ 
Expanded(
  child:   Text('المؤذن: ${post['Muathen name']}',textAlign: TextAlign.right,
  
                                    style: new TextStyle(
  
                                        fontFamily: 'Elmessiri',
  
                                 //     fontWeight: FontWeight.bold,
  
                                        fontSize: 18,
  
                                        color: Color.fromARGB(255, 20, 5, 87))),
),
                            
                            Icon(
                              Icons.person_2_outlined,
                              color: Color.fromRGBO(212, 175, 55, 1),
                              size: 40 ,
                            ),

],

  
),














                            
                       
],),

Column(
  
                children: const [
                    Divider(
                    color:  Color.fromARGB(255, 166, 165, 167),
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
                    height: 60,
                  ),
                  Text(
                    'لا يوجد مستجدات حالية',
                    style: TextStyle(
                      fontSize: 14,
                      //fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 166, 165, 167),
                      fontFamily: 'Elmessiri',
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    // child: Text("Bottom text"),
                  )
                ],
              ),



                        
                      ],),),],),],),),
                    
                    );
        
  }
}
