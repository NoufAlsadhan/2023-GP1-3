import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mehrab/ItemDetailsScreen.dart';

class Readlistview extends StatefulWidget{

const Readlistview ({super.key}) ;

@override
State<Readlistview> createState()=> _ReadlistviewState();
}

class _ReadlistviewState extends State<Readlistview>{
  

final _mosque = FirebaseFirestore.instance.collection('Mosque').snapshots();
final db = FirebaseFirestore.instance; 
var id;


navigateToDetail(DocumentSnapshot post){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemDetailsScreen(post=post,)));
}


@override
Widget build (BuildContext context){
  return Scaffold(
appBar: AppBar(
shape: RoundedRectangleBorder(

borderRadius: BorderRadius.vertical(
bottom: Radius.circular(20),

 ),

),
centerTitle: true,
title: Align(
            child:Text(
           "قائمة المساجد",
           style: TextStyle(fontFamily: 'Elmessiri'),
         ),
         ),

  automaticallyImplyLeading: false,
  backgroundColor:  Color.fromARGB(255, 20, 5, 87),
        ),
 
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

body:Container(
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage("images/background2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
  child:StreamBuilder(  
  
          stream:_mosque,
  
          builder:(context, snapshot){
  
            if(snapshot.hasError){
  
             return const Text('مشكلة بالاتصال');
  
            }
  
           if(snapshot.connectionState== ConnectionState.waiting){
  
            return const Text('...جاري التحميل');
  
            }
  
           if (snapshot.data == null) {
  
          return const Text('no data');
  
           }
  
  
  
          var docs = snapshot.data!.docs;
  
  
  
  
  
           return ListView.builder(
  
             padding: EdgeInsets.only(top: 20.0),
  
              itemCount: docs.length,
  
              
  
              itemBuilder: (context, index){
  
  
  
              return Card(child : ListTile(
  
                
  
                shape: RoundedRectangleBorder( 
  
                side: BorderSide(width: 1, color:Color.fromARGB(255, 213, 213, 213)),
  
                borderRadius: BorderRadius.circular(10),
  
                  ),         
  
              
  
        onTap: () {
  
        navigateToDetail(docs[index]);
  
        },
  
            trailing: Container(
  
              width:80,
  
              height: 80,
  
              child: ClipRRect(
  
              borderRadius: BorderRadius.circular(18),
  
              child: Image.network(docs[index]['Image'], 
  
              fit: BoxFit.cover ,
  
                    ),
  
                   ),
  
            ), 
  
                title: Text(docs[index]['Name'],textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Elmessiri'),),
                subtitle:Text ( 'حي '+ docs[index]['District'] ,textAlign: TextAlign.right,  style: TextStyle(fontFamily: 'Elmessiri'),),
  
                
  
                ),);
              });
          }

  
          ),
),
        
  );
}
}