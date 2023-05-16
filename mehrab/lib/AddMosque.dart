
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:mehrab/AddMosque.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math';
import 'dart:math' as math;



final _formKey = GlobalKey<FormState>();
final _controller = TextEditingController();
final TextEditingController _Mosquenum = TextEditingController();
final TextEditingController _MosqueNameController = TextEditingController();
final TextEditingController _District = TextEditingController();
final TextEditingController _LocLink = TextEditingController();
final TextEditingController _ImamName = TextEditingController();
final TextEditingController _MuathenName = TextEditingController();
final TextEditingController _MosqueImage = TextEditingController();
var db = FirebaseFirestore.instance;
String imageUrl='';
//GoogleMapController? _Loccontroller;
  //Set<Marker> _markers = Set<Marker>();
  


class AddMosque extends StatefulWidget {
  _AddMosqueState createState() => _AddMosqueState();
}


class _AddMosqueState extends State<AddMosque> {
  final _controller = TextEditingController();

  

void initState() {
    super.initState();
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Mosque');
    late Stream<QuerySnapshot> _stream;
    _stream = collectionRef.snapshots();
    _Mosquenum.text = ''; //1
    _MosqueNameController.text = ''; //2
    _District.text = ''; //3
    _LocLink.text = ''; //4
    _ImamName.text = ''; //5
   _MuathenName.text = ''; //6
  _MosqueImage.text = ''; //7
  }


  bool _visible = false;
  bool _visible2 = false;
  var numberErrorMessageI = '';
  var ImageErrorMessage='';
    var UrlErrorMessage='';
    var MosqueNameErrorMessage='';
  //var validNumErrorMessage ='';
    var validNum = true;
    var validUrl = true;
    var validMname = true;
  
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = false;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mehrab',
        home: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: Text(
                'إضافة مسجد جديد',
                style: TextStyle(fontFamily: 'Elmessiri'),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 20, 5, 87),
              leading: Container(), // Remove the leading back button
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
            ),
            
            
//padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
               body: Container(
                decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SingleChildScrollView(
              child: Form (
                key: _formKey,
                  child: Center(
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                      
                    ),
                    
                    Container(
                      //height: 100,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _Mosquenum,
                          onFieldSubmitted: validateNum, 
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: validNum == false
                                  ? numberErrorMessageI
                                  : null,
                                  contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: ' *رقم المسجد',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: "Elmessiri",
                                    fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      //height: 100,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _MosqueNameController,
                          onFieldSubmitted: validateMosqueName,
                          decoration: InputDecoration(
                            errorText: validMname == false ? MosqueNameErrorMessage : null,
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: ' *اسم المسجد',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: "Elmessiri",
                                    fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),



                    Container(
                      //height: 100,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _District,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  *الحي',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: "Elmessiri",
                                    fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),

                    

                    Container(
                      //height: 100,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _ImamName,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  *اسم الإمام',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: "Elmessiri",
                                    fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      //height: 100,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _MuathenName,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  *اسم المؤذن',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: "Elmessiri",
                                    fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ),



                     const SizedBox(height: 20,),
                      
                     
                     
                     Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child : Text(' *أضف صورة المسجد :'  ,style: TextStyle(fontFamily: 'Elmessiri', fontSize: 12),

                        ),),
                     ),

                   
                        
                     
                       Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: IconButton(
                          onPressed: () async{
                            
                           ImagePicker imagePicker= ImagePicker();
                           XFile? file = await imagePicker.pickImage(source:ImageSource.gallery);
                           print('${file?.path}');
                           
                           if(file == null) return;

                           String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
                           Reference referenceRoot = FirebaseStorage.instance.ref();
                           Reference referenceDirImages = referenceRoot.child('images');
                           Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                           
                          try{
                                await referenceImageToUpload.putFile(File(file!.path));
                                setState(() async {
                                  imageUrl=await referenceImageToUpload.getDownloadURL();
                                  print(imageUrl);

                                  if(imageUrl.isNotEmpty==true){
                      _toggle2();
                     }

                                }); 

                             }catch(error){
                               //some error 
                               
                             }

                            
                          },
                           icon: Icon(Icons.camera_alt , color: Color.fromARGB(255, 20, 5, 87),)),
                      ),
                    ),

                    Visibility(
                          visible: _visible2,
                          child: Text('تم إدراج صورة المسجد بنجاح' ,
                              style: TextStyle(color: Colors.green))), 

                     
                      

                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _LocLink,
                          onFieldSubmitted: validateUrl,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15),
                            errorText: validUrl == false
                                  ? UrlErrorMessage : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  *رابط الموقع',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: "Elmessiri",
                                    fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    ), 

const SizedBox(height: 20,),

                       Visibility(
                          visible: _visible,
                          child: Text(' جميع الحقول مطلوبة *',
                              style: TextStyle(color: Colors.red))),
                   
                     
                    

      

                    Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                primary: Color.fromARGB(255, 20, 5, 87),
                              ),
                              child: const Text('إضافة المسجد',
                                  style: TextStyle(fontFamily: 'Elmessiri')),
                              onPressed: () async {

                              

                                bool empt = false;
                                bool falselength = false;
                                 if (_Mosquenum.text.isEmpty ||
                                    _MosqueNameController.text.isEmpty ||
                                    _District.text.isEmpty ||
                                    _LocLink.text.isEmpty ||
                                    _ImamName.text.isEmpty ||
                                    _MuathenName.text.isEmpty ||
                                    imageUrl.isEmpty ||
                                    _Mosquenum.text == '' ||
                                    _MosqueNameController.text == '' ||
                                    _District.text == '' ||
                                    _LocLink.text == '' ||
                                    _ImamName.text == '' ||
                                    _MuathenName.text == '' ||
                                    imageUrl == '') {
                                  empt = true;
                                  _toggle();
                                }

                                if (_Mosquenum.text.isNotEmpty &&
                                    _MosqueNameController.text.isNotEmpty &&
                                    _District.text.isNotEmpty &&
                                    _LocLink.text.isNotEmpty &&
                                    _ImamName.text.isNotEmpty &&
                                    _MuathenName.text.isNotEmpty &&
                                    imageUrl.isNotEmpty &&
                                    _Mosquenum.text != '' &&
                                    _MosqueNameController.text != '' &&
                                    _District.text != '' &&
                                    _LocLink.text != '' &&
                                    _ImamName.text != '' &&
                                    _MuathenName.text != '' &&
                                    imageUrl != '') {
                                  empt = false;
                                  _toggle1();
                                }

                                if (_Mosquenum.text.length != 4 ) {
                                  falselength = true;
                                }

                                if (empt == false && 
                                falselength == false &&
                                 validNum == true) {
                                  
                                  final MosqueData = {
                                    
                                    //"ID": _Mosquenum.text,  
                                    "Name": _MosqueNameController.text,
                                    "District": _District.text,
                                    "Location": _LocLink.text,
                                    "Imam name": _ImamName.text,
                                    "Muathen name": _MuathenName.text,
                                    "Image": imageUrl,

                                  };

                                 var uri= Uri.parse(_LocLink.text);
                                 print(uri);

                                   

                                  showAlertDialog(
                                      context,
                                      MosqueData);
                                  
                                }
                                setState(() {});
                                

                              })),
                    
                    
                  ],
                ),
              ),
            )))
    ));
  }
  
void _toggle() {
    setState(() {
      _visible = true;
    });
  }

  void _toggle1() {
    setState(() {
      _visible = false;
    });
  }

  void _toggle2() {
    setState(() {
      _visible2 = true;
    });
  }



validateUrl(String text) async {
    var v = true;
    
      if(!text.startsWith('https://goo.gl/maps')){
      setState(() {
        validUrl = false;
        UrlErrorMessage = 'الرابط المرفق يجب أن يكون صحيح';
        v = false;
      });
    } else if (text.startsWith('https://goo.gl/maps')){
      setState(() {
      validUrl=true;
       
    });
    }

}//End validate URL

validateMosqueName(String text) async {
  
    var v = true;
    
      if(!(text.startsWith('مسجد')) || (!text.startsWith('جامع'))){
      setState(() {
        validMname = false;
        MosqueNameErrorMessage = 'يجب أن يبدأ الاسم بـ : جامع أو مسجد';
        v = false;
      });
    }  if ((text.startsWith('مسجد')) || text.startsWith('جامع')){
      setState(() {
        print('hello');
        validMname=true;
      
       
    });
    }

}//End validate Mosque Name   


  
   validateNum(String text) async {
    var v = true;
    if (!(text.length == 4) && text.isNotEmpty) {
      setState(() {
        validNum = false;
        numberErrorMessageI = 'رقم المسجد يجب   أن يتكون من 4 أرقام فقط';
        v = false;
      });
    } 
    else{
      DocumentReference documentRef = FirebaseFirestore.instance.collection('Mosque').doc(text);
      DocumentSnapshot snapshot = await documentRef.get();
      if (snapshot.exists) {
      setState(() {
          validNum = false;
          numberErrorMessageI = "رقم المسجد مسجَّل مسبقًا";
          v = false;
        });
    
    
String documentId = snapshot.id;
print('Document ID: $documentId');
} else {
print('Document does not exist');
}

    db
        .collection("Mosque").doc(text)
        .get()
        .then((querySnapshot) {

    });



    if (v == true) {
      setState(() {
        validNum = true;
      });
    }
  }
   }

   

     showAlertDialog(
      BuildContext context,
      Map<String, Object> MosqueData,
      ) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء", style: TextStyle(fontFamily: 'Elmessiri', color: Colors.red)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("إضافة", style: TextStyle(fontFamily: 'Elmessiri')),
      onPressed: () {


        Add(MosqueData);
        Navigator.pop(context);

        _Mosquenum.clear();
        _MosqueNameController.clear();
        _District.clear();
        _LocLink.clear();
        _ImamName.clear();
        _MuathenName.clear();
        imageUrl='' ;

        
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(" إضافة مسجد",
            style: TextStyle(
                fontFamily: 'Elmessiri',
                color: Color.fromARGB(255, 20, 5, 87))),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text("هل أنت متأكد من المعلومات المعطاة لإضافة المسجد ؟",
            style: TextStyle(fontFamily: 'Elmessiri')),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  

  Add(
      Map<String, dynamic> MosqueData,
      ) 
      { 
    db
        .collection('Mosque')
        .doc(_Mosquenum.text)
        //.doc()
        .set(MosqueData)
        .onError((e, _) => print("Error writing document: $e"));

      }

}




