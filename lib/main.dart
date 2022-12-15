import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:contact_management/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';

import 'editContact.dart';
import 'imageUitlity.dart';

late Database database;
bool databaseAvilable = false;
String imageBase = "";
String searchQuery = "";

TextEditingController nameController = new TextEditingController();
TextEditingController mobileController = new TextEditingController();
TextEditingController emailController = new TextEditingController();
TextEditingController genderController = new TextEditingController();
TextEditingController addresscontroller = new TextEditingController();
var image;
void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
//opendb();

  //getDbPath();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.light(),
          home: splashScreeen(),
        );
      },
    );
  }
}

// Future<void> getDbPath() async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'contacts_db.db');
//   // openDatabase(path) as Database;
//   print(path);
// }

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
           // opendb();
            addNewContact(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15.sp)),
            child: Container(
              color: Color(0xFFdf3a5c),
              child: Padding(
                padding:  EdgeInsets.all(8.0.sp),
                child: Text("+ New Contact",
                    style: GoogleFonts.montserrat(fontSize: 16.sp,
                    color: Colors.white)),
              ),
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(232,232,232,9),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //width: 90.w,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 14.h,
                      width:14.h ,
                        child: Image.asset("assets/contacts_management.png")
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Contacts",
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding:  EdgeInsets.all(8.0.sp),
                child: TextField(
                  onChanged: (test){
                    setState(() {
                      searchQuery = test;
                    });
                  },
                  style: GoogleFonts.montserrat(
                      color: Colors.grey.shade700, fontSize: 11.sp),
                  decoration: InputDecoration(
                    hintText: "Search Here . . ",
                    focusColor: Colors.black,
                    fillColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.sp,
                        color: Colors.black,
                        //strokeAlign: StrokeAlign.inside
                      ),
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.sp,
                        color: Colors.grey,
                        //strokeAlign: StrokeAlign.inside
                      ),
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                  ),
                ),
              ),

              Container(
                height: 80.h,
                child: FutureBuilder(
                    future: getContacts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return (snapshot.data!=null)
                          ? RefreshIndicator(
                        onRefresh: (){
                          return Future.delayed(
                            Duration(seconds: 1),
                                () {
                              setState(() {
                              });

                            },
                          );
                        },
                            child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return contactWidget(contactData: snapshot.data[index],);
                            }),
                          )
                          :Container(
                        height: 40.h,
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: CircularProgressIndicator(),
                            )),
                      );
                    }
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class contactWidget extends StatefulWidget {
  var contactData;
   contactWidget({Key? key,@required this.contactData,}) : super(key: key);

  @override
  State<contactWidget> createState() => _contactWidgetState();
}

class _contactWidgetState extends State<contactWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.sp,
        right: 8.sp,
        top: 5.sp,
      ),
      child: GestureDetector(
        onTap: () {
          imageBase = "";
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => editContact(contact: widget.contactData,)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.sp)),
          child: Container(
            width: 100.w,
            height: 7.h,
            color: Colors.white,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.sp, left: 8.sp),
                        child: Text(
                          widget.contactData["name"],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.sp),
                        child: Text(
                          widget.contactData["mobileNumber"],
                          style: GoogleFonts.montserrat(
                              //fontWeight: FontWeight.w600,
                              fontSize: 9.sp,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.sp),
                    child: Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

addNewContact(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.sp),
        child: Container(
          height: 80.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    child: Text(
                      "Name",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Container(
                    width: 100.w,
                    child: TextField(
                      controller: nameController,
                      style: GoogleFonts.montserrat(
                          color: Colors.grey.shade700, fontSize: 11.sp),
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.black,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.grey,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 3.sp,
              ),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    child: Text(
                      "Mobile Number",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Container(
                    width: 100.w,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: mobileController,
                      style: GoogleFonts.montserrat(
                          color: Colors.grey.shade700, fontSize: 11.sp),
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.black,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.grey,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 3.sp,
              ),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    child: Text(
                      "Email",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Container(
                    width: 100.w,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: GoogleFonts.montserrat(
                          color: Colors.grey.shade700, fontSize: 11.sp),
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.black,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.grey,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 3.sp,
              ),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    child: Text(
                      "Gender",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Container(
                    width: 100.w,
                    child: TextField(
                      controller: genderController,
                      style: GoogleFonts.montserrat(
                          color: Colors.grey.shade700, fontSize: 11.sp),
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.black,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.grey,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                      ),
                    ),
                  )),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    child: Text(
                      "Address",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Container(
                    width: 100.w,
                    child: TextField(
                      controller: addresscontroller,
                      style: GoogleFonts.montserrat(
                          color: Colors.grey.shade700, fontSize: 11.sp),
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.black,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: Colors.grey,
                            //strokeAlign: StrokeAlign.inside
                          ),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                      ),
                    ),
                  )),
              GestureDetector(
                onTap: () {
                  //getContacts();
                  //saveContact(context);
                  print("add Imahge");
                  pickImageFromGallery();
                  //selectImageFromGallery();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                  child: Container(
                    color: Color(0xFFdf3a5c),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Add Image",
                          style: GoogleFonts.montserrat(fontSize: 12.sp,color: Colors.white)),
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  //getContacts();
                  saveContact(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                  child: Container(
                    color: Color(0xFFdf3a5c),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Save",
                          style: GoogleFonts.montserrat(fontSize: 12.sp,color: Colors.white)),

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void saveContact(BuildContext context) {
  //opendb();
if(mobileController.text.toString().length==10){
  showAlertDialog(context, "Saving");
  database.transaction((txn) async {
    // int id1 = await txn.rawInsert(
    //     'INSERT INTO contactTable (name, mobileNumber, email,gender,address) VALUES(" ", 1234, 456.789,"gender","address")');
    // print('inserted1: $id1');
    int id2 = await txn.rawInsert(
        'INSERT INTO contactTable(name, mobileNumber, email,gender,address,photo) VALUES(?, ?, ?,?,?,?)',
        [
          nameController.text,
          mobileController.text,
          emailController.text,
          genderController.text,
          addresscontroller.text,
          imageBase.toString()

        ]);
    // database.close();

  });

  Navigator.pop(context);
  Navigator.pop(context);
}else{
//  Navigator.pop(context);
  SnackBar snackBar = SnackBar(
    content: Text('Invalid Data'),
    action: SnackBarAction(
      label: 'Okay',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Navigator.pop(context);
}
}



Future<List> getContacts() async {
  //await opendb();
  List<dynamic> list = await database.rawQuery('SELECT * FROM contactTable WHERE name LIKE "$searchQuery%"');
 // List<dynamic> list = await database.rawQuery('SELECT * FROM contactTable');
  print(list);
 // print(list);
 // database.close();
  return list;
}



Future<void> updateContact(BuildContext context, int id) async {
  showAlertDialog(context, "Saving");
  print("Update called");

 // await opendb();
  database.transaction((txn) async {

    int count = await txn.rawUpdate(
        'UPDATE contactTable SET name = ?, mobileNumber = ?, email = ?,gender = ? ,address = ?, photo= ? WHERE id = ?',
        [
          EditnameController.text,
          EditmobileController.text,
          EditemailController.text,
          EditgenderController.text,
          EditaddressController.text,
          imageBase,
          id
        ]);
 //   database.close();
    print('updated: $count');
    Navigator.pop(context);
    Navigator.pop(context);
  } );

}
void deleteContact(BuildContext context, int id){
  showAlertDialog(context, "Saving");
  print("Update called");

  // await opendb();
  database.transaction((txn) async {

    int count = await txn.rawUpdate(
        'DELETE FROM contactTable  WHERE id = ?',
        [id]);
    //   database.close();
    print('updated: $count');
    Navigator.pop(context);
  } );
}

showAlertDialog(BuildContext context, String content) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 3.sp,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                content,
                style: GoogleFonts.montserrat(),
              )),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


pickImageFromGallery() {
  ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
    var imageBytes = await imgFile?.readAsBytes();
    String imgString = Utility.base64String(imageBytes!);
    imageBase = imgString;
    print(imgString);
    //imah

  });
}


class profileImage extends StatefulWidget {
  final String imagePath;
   profileImage({Key? key, @required imageUrl, required this.imagePath}) : super(key: key);
  @override _profileImageState createState() => _profileImageState();
}

class _profileImageState extends State<profileImage> {

  @override
  Widget build(BuildContext context) {
    return

      GestureDetector(
        onTap: (){
          pickImageFromGallery();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.sp),
          child: Container(
              width: 15.h,
              height: 15.h,
              child: Utility.imageFromBase64String(widget.imagePath),
              // height: 190.0,
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     image: DecorationImage(
              //         fit: BoxFit.fill,
              //         image:
              //       // NetworkImage(
              //       //   newFirebaseURL =="" ?c.dummyProfile: newFirebaseURL,
              //       //  // c.profileImageURL ==""? firebaseImageURL==""? c.dummyProfile: firebaseImageURL :
              //       // )
              //     )
              // )
              //
          ),
        ),
      );
  }
}