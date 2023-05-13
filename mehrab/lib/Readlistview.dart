import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mehrab/ItemDetailsScreen.dart';

//final DocumentReference documentReference = FirebaseFirestore.instance.collection('Mosquee').doc();
//final String docId = documentReference.id;

class Readlistview extends StatefulWidget{

const Readlistview ({super.key}) ;

@override
State<Readlistview> createState()=> _ReadlistviewState();
}

class _ReadlistviewState extends State<Readlistview>{
  
//final storage = FirebaseFirestore..instance;
final _mosque = FirebaseFirestore.instance.collection('Mosque').snapshots();
final db = FirebaseFirestore.instance; 
var id;
//final DocumentSnapshot documentSnapshot = docs;

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

title: Align(
            alignment:Alignment.centerRight,
            child:Text(
           "قائمة المساجد",
           style: TextStyle(fontFamily: 'Elmessiri'),
         ),
         ),



leading:Container(
    // Add padding around the search bar
    // padding: const EdgeInsets.only(left: 5 , right: 0.000099999999 ,top: 8,bottom: 8),
    // Use a Material design search bar
    child: TextField(
      //controller: _searchController,
      decoration: InputDecoration(
        //contentPadding: EdgeInsets.symmetric(vertical: 40),
        
        // Add a clear button to the search bar
        /*suffixIcon: IconButton(
          icon: Icon(Icons.clear, color: Color.fromARGB(255, 242, 240, 240),),
          onPressed: () => _searchController.clear(),
        ),*/
        
        // Add a search icon or button to the search bar
        prefixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.white,),
          onPressed: () {
        
        // Perform the search here
          },
        ),
      ),
    ),
  ),   
  backgroundColor:  Color.fromARGB(255, 20, 5, 87),
        ),
       


    bottomNavigationBar: BottomNavigationBar(
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
        icon: Icon(Icons.home,color: Colors.blue),
        label: 'الرئيسية',
      ),
      

    ],
  ),



 
body:StreamBuilder(  
  
  
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
        
       

          //if(QuerySnapshot.docs.isNotEmpty){
          //final DocumentSnapshot documentSnapshot= QuerySnapshot.docs.first;
          // id=docs.id;
          //}


         
         //final DocumentSnapshot documentSnapshot = uerySnapshot.docs.first;
        
          //return Text('${docs.length}')

         return ListView.builder(
           padding: EdgeInsets.only(top: 20.0),
            itemCount: docs.length,
            
            itemBuilder: (context, index){
//boxShadow: [
//      BoxShadow(color: Colors.black.withOpacity(50), blurRadius: 50),
//    ];
            return Card(child : ListTile(
              
              shape: RoundedRectangleBorder( 
              side: BorderSide(width: 1, color:Color.fromARGB(255, 213, 213, 213)),
              borderRadius: BorderRadius.circular(10),
                ),
            //  print(docs[index]);
            
      onTap: () {
        // Handle list item tap here
      /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  ItemDetailsScreen(index)),
                    );

      },*/
    

      navigateToDetail(docs[index]);
      },
          trailing:  Container(
            width:80,
            height: 80,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(docs[index]['Image'], 
            fit: BoxFit.cover ,
                  ),
                 ),
          ),
          
             // trailing: Image.network(docs[index]['img'], borderRadius: BorderRadius.circular(20), ),
              
              title: Text(docs[index]['Name'],textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Elmessiri'),),
              subtitle:Text (docs[index]['District'],textAlign: TextAlign.right,  style: TextStyle(fontFamily: 'Elmessiri'),),
              
              ),);
               
            });
        }
        
        ),
  );
}
}