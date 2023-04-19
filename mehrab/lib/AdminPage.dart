import 'package:flutter/material.dart';
//import 'package:flutter/src/material/dropdown.dart';

List<String> itemsList = ['خالد', 'محمد', 'عاصم','صالح','عبدالله'];
String? selectedItem = 'خالد';


class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mehrab',
        home: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: const BackButton(
                color: Colors.white, // <-- SEE HERE
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
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                      
                    ),
                    
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ),
                            labelText: ' معرِّف المسجد',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          //obscureText: true,
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          //obscureText: true,
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

                    const SizedBox(height: 20,),
                    


                    /* Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ), 
                            labelText: '  اختر إمام المسجد',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                          ),
                        ),
                      ),
                    ), */ 

                    
                      Container(
                        decoration:  BoxDecoration(
                                   borderRadius: BorderRadius.circular(90.0),
                                   border: Border.all(color:Color.fromARGB(255, 20, 5, 87), width: 1),
                                ), 
                        width: 370,
                        height: 60, 
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration( 
                            labelText: 'اختر إمام المسجد',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                            prefixIcon: Icon(
                              Icons.accessibility_rounded,
                              color: Color.fromARGB(255, 20, 5, 87), 
                            ),
                             /* border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ), */

                          ),
                          iconSize: 25,
                          icon: Icon(Icons.arrow_drop_down_circle, color: Color.fromARGB(255, 20, 5, 87)),
                              borderRadius: BorderRadius.circular(20), // هذا الراديس حق الخيارات
                                value: selectedItem,
                                items: itemsList
                                .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: TextStyle(fontSize: 15))))
                                  .toList(),
                                  onChanged: (item) => setState(() => selectedItem = item)
                                  ),
                                  ),
                                  ),

                       const SizedBox(height: 20,), // this line insert a space between elements

                     Container(
                        decoration:  BoxDecoration(
                                   borderRadius: BorderRadius.circular(90.0),
                                   border: Border.all(color:Color.fromARGB(255, 20, 5, 87), width: 1),
                                ), 
                        width: 370,
                        height: 60, 
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration( 
                            labelText: 'اختر مؤذن المسجد',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 5, 87),
                            ),
                            prefixIcon: Icon(
                              Icons.accessibility_rounded,
                              color: Color.fromARGB(255, 20, 5, 87), 
                            ),
                             /* border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 20, 5, 87),
                                  width: 1),
                            ), */

                          ),
                          iconSize: 25,
                          icon: Icon(Icons.arrow_drop_down_circle, color: Color.fromARGB(255, 20, 5, 87)),
                              borderRadius: BorderRadius.circular(20), // هذا الراديس حق الخيارات
                                value: selectedItem,
                                items: itemsList
                                .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: TextStyle(fontSize: 15))))
                                  .toList(),
                                  onChanged: (item) => setState(() => selectedItem = item)),
                      ),
                      ),
                      

                      const SizedBox(height: 20,),


                    Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                           // minimumSize: const Size.fromHeight(50),
                            primary: Color.fromARGB(255, 20, 5, 87),
                          ),
                          child: const Text(' إضافة المسجد',
                              style: TextStyle(fontFamily: 'Elmessiri')),
                          onPressed: () {},
                        )),
                    
                  ],
                ),
              ),
            )));
  }
  
  setState(String? Function() param0) {}



}




