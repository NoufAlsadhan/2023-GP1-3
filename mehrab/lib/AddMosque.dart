
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:mehrab/AddMosque.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';



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
GoogleMapController? _Loccontroller;
  Set<Marker> _markers = Set<Marker>();
  


class AddMosque extends StatefulWidget {
  _AddMosqueState createState() => _AddMosqueState();
}


class _AddMosqueState extends State<AddMosque> {
//Sending sms with creditials
  final _controller = TextEditingController();

  

void initState() {
    super.initState();
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Mosque');
    _Mosquenum.text = ''; //1
    _MosqueNameController.text = ''; //2
    _District.text = ''; //3
    _LocLink.text = ''; //4
    _ImamName.text = ''; //5
   _MuathenName.text = ''; //6
  _MosqueImage.text = ''; //7
  }

//collectionRef.add(dataToSave);
  bool _visible = false;
  var numberErrorMessageI = '';
  var ImageErrorMessage='';
  //var validNumErrorMessage ='';
    var validNum = true;
  
  

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
              leading:  BackButton(
                color: Colors.white,
                onPressed: () {
                    Navigator.pop(context);
                  } // <-- SEE HERE
              ),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ' إضافة مسجد جديد',
                  style: TextStyle(fontFamily: 'Elmessiri'),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 20, 5, 87),
            ),
            
            /*body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background2.jpg"),
                  fit: BoxFit.cover,
                ),
              ), */
//padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
               body: Container(
                //height: 500,
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: ' رقم المسجد',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
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
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: ' اسم المسجد',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  الحي',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //const SizedBox(height: 20,),

                    Container(
                      //height: 100,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _ImamName,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  اسم الإمام',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  اسم المؤذن',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                          ),
                        ),
                      ),
                    ),


                     const SizedBox(height: 20,),

                     Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child : Text(' : أضف صورة المسجد '  ,style: TextStyle(fontFamily: 'Elmessiri'),

                        ),),
                     ),

                     //const SizedBox(height: 20,),
                     //const SizedBox(height: 20,),
                        

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

                                }); 

                             }catch(error){
                               //some error occured 
                             }

                            
                            //print ('$imageUrl lama');
                          },
                           icon: Icon(Icons.camera_alt)),
                      ),
                    ),


                      

                      
                      /* Container (
                        height:300,
                         //padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: GoogleMap( initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _Loccontroller = controller;

          // Add marker to the map
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('marker_1'),
                position: LatLng(37.42796133580664, -122.085749655962),
                infoWindow: InfoWindow(title: 'Googleplex'),
              ),
            );
          });
        },
      ),), */
                       


                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _LocLink,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: '  رابط الموقع',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                          ),
                        ),
                      ),
                    ), 

                    
                    Visibility(
                          visible: _visible,
                          child: Text(' جميع الحقول مطلوبة *',
                              style: TextStyle(color: Colors.red))),   
                    
                     // const SizedBox(height: 20,),

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
                                 if (//_Mosquenum.text.isEmpty ||
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

                                if (//_Mosquenum.text.isNotEmpty &&
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
                                    
                                    "ID": _Mosquenum.text,  
                                    "Name": _MosqueNameController.text,
                                    "District": _District.text,
                                    "Location": _LocLink.text,
                                    "Imam_name": _ImamName.text,
                                    "Muathen_name": _MuathenName.text,
                                    "Image": imageUrl,

                                  };
                                   

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

/*validateImage(String text) async {
    var v = true;
    if (text.isNotEmpty) {
      setState(() {
        validNum = false;
        ImageErrorMessage = 'تمت إضافة الصورة بنجاح';
        v = false;
      });
    } 
    else{ 
      ImageErrorMessage ='قم بإضافة صورة للمسجد';
    }
} */
  
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
        //.where(firebase.firestore.FieldPath.documentId(), '==', 'fK3ddutEpD2qQqRMXNW5')
        //.where( , isEqualTo: text)
        .get()
        .then((querySnapshot) {
      /* if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          validNum = false;
          numberErrorMessageI = "رقم المسجد مسجَّل مسبقًا";
          v = false;
        });
      } */
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
      child: Text("إلغاء", style: TextStyle(fontFamily: 'Elmessiri')),
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
        

        db
        .collection('Mosque')
        //.doc(_Mosquenum)
        .doc()
        .set(MosqueData)
        .onError((e, _) => print("Error writing document: $e"));

    

   
      }

 // setState(String? Function() param0) {}

}




