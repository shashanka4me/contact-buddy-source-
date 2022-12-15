import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';
late Database databaseEditcontact;
TextEditingController EditnameController = new TextEditingController();
TextEditingController EditmobileController = new TextEditingController();
TextEditingController EditemailController = new TextEditingController();
TextEditingController EditgenderController = new TextEditingController();
TextEditingController EditaddressController = new TextEditingController();
class editContact extends StatefulWidget {
  var contact;
   editContact({Key? key, @required this.contact}) : super(key: key);

  @override
  State<editContact> createState() => _editContactState();
}

class _editContactState extends State<editContact> {



  @override
  Widget build(BuildContext context) {
    EditnameController.text = widget.contact["name"];
    EditmobileController.text = widget.contact["mobileNumber"];
    EditemailController.text = widget.contact["email"];
    EditgenderController.text = widget.contact["gender"];
    EditaddressController.text = widget.contact["address"];
    return SafeArea(
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: (){
            //opendb();
            //getContacts();


            updateContact(context, widget.contact["id"]);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15.sp)),
            child: Container(
              color: Color(0xFFdf3a5c),
              child: Padding(
                padding:   EdgeInsets.all(8.0.sp),
                child: Text("Update Contact",
                    style: GoogleFonts.montserrat(fontSize: 14.sp,color: Colors.white)),

              ),
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(245, 245, 245, 10),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 28.sp,),
                  Spacer(),
                  Center(
                    child: Container(
                      height: 14.h,
                      width:14.h ,
                      child: Image.asset("assets/contacts_management.png")
                ),
                  ),
                  // Container(
                  //   width: 85.w,
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //     ),
                  //   ),
                  // ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      deleteContact(context, widget.contact["id"]);
                      Navigator.pop(context);
                      //opendb();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                      child: Container(
                       // color: Colors.red,
                        child: Padding(
                          padding:   EdgeInsets.all(8.0.sp),
                          child: Icon(Icons.delete,size: 20.sp,)
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              Padding(
                padding:   EdgeInsets.all(8.0.sp),
                child: Text("Edit Contact",
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp, fontWeight: FontWeight.w500
                    )),
              ),
              SizedBox(height: 5.sp,),
              editWidget(userDetails: widget.contact,)
            ],
          ),
        ),
      ),
    );
  }
}

class editWidget extends StatefulWidget {
  var userDetails;
    editWidget({Key? key, @required this.userDetails}) : super(key: key);

  @override
  State<editWidget> createState() => _editWidgetState();
}

class _editWidgetState extends State<editWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.sp)),
      child: Container(
        width: 100.w,
       // color: Color.fromRGBO(245, 245, 245, 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            widget.userDetails["photo"]!=""?
            profileImage(imagePath:  widget.userDetails["photo"])
            :Container(),
            ListTile(
                title: Padding(
                  padding:   EdgeInsets.only(bottom: 10.sp),
                  child: Text("Name",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600
                    ),),
                ),
                subtitle: Container(
                  width: 100.w,
                  child: TextField(
                    controller: EditnameController,
                    style: GoogleFonts.montserrat(
                        color: Colors.grey.shade700,
                        fontSize: 11.sp
                    ),
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
                      border:OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.sp,
                          color: Colors.grey,
                          //strokeAlign: StrokeAlign.inside
                        ),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),

                    ),
                  ),
                )
            ),
            SizedBox(height: 3.sp,),
            ListTile(
                title: Padding(
                  padding:   EdgeInsets.only(bottom: 10.sp),
                  child: Text("Mobile Number",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600
                    ),),
                ),
                subtitle: Container(
                  width: 100.w,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: EditmobileController,
                    style: GoogleFonts.montserrat(
                        color: Colors.grey.shade700,
                        fontSize: 11.sp
                    ),
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
                      border:OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.sp,
                          color: Colors.grey,
                          //strokeAlign: StrokeAlign.inside
                        ),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),

                    ),
                  ),
                )
            ),
            SizedBox(height: 3.sp,),
            ListTile(
                title: Padding(
                  padding:   EdgeInsets.only(bottom: 10.sp),
                  child: Text("Email",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600
                    ),),
                ),
                subtitle: Container(
                  width: 100.w,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: EditemailController,
                    style: GoogleFonts.montserrat(
                        color: Colors.grey.shade700,
                        fontSize: 11.sp
                    ),
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
                      border:OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.sp,
                          color: Colors.grey,
                          //strokeAlign: StrokeAlign.inside
                        ),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),

                    ),
                  ),
                )
            ),
            SizedBox(height: 3.sp,),
            ListTile(
                title: Padding(
                  padding:   EdgeInsets.only(bottom: 10.sp),
                  child: Text("Gender",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600
                    ),),
                ),
                subtitle: Container(
                  width: 100.w,
                  child: TextField(
                    controller: EditgenderController,
                    style: GoogleFonts.montserrat(
                        color: Colors.grey.shade700,
                        fontSize: 11.sp
                    ),
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
                      border:OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.sp,
                          color: Colors.grey,
                          //strokeAlign: StrokeAlign.inside
                        ),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),

                    ),
                  ),
                )
            ),
            ListTile(
                title: Padding(
                  padding:   EdgeInsets.only(bottom: 10.sp),
                  child: Text("Address",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600
                    ),),
                ),
                subtitle: Container(
                  width: 100.w,
                  child: TextField(
                    controller: EditaddressController,
                    style: GoogleFonts.montserrat(
                        color: Colors.grey.shade700,
                        fontSize: 11.sp
                    ),
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
                      border:OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.sp,
                          color: Colors.grey,
                          //strokeAlign: StrokeAlign.inside
                        ),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),

                    ),
                  ),
                )
            ),

          ],
        ),
      ),
    );
  }
}

