import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:contact_management/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';

bool databaseOpened = true;

class splashScreeen extends StatefulWidget {
  const splashScreeen({Key? key}) : super(key: key);

  @override
  State<splashScreeen> createState() => _splashScreeenState();
}

class _splashScreeenState extends State<splashScreeen> {
  @override
  Widget build(BuildContext context) {
    if(databaseOpened){
      opendb();
      Timer(
          Duration(seconds: 5),
              () => {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mainScreen())),
          });

    }

    //Print()
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,

        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: Container(
              height: 18.h,
              width:18.h ,
              // color: Colors.red,
              child: Image.asset("assets/contacts_management.png")
            ),
          ),
        ),
      ),
    );
  }
}
Future<void> opendb() async {
  databaseOpened = false;
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'contact_db.db');

  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
    print("Db not found");
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              ' CREATE TABLE IF NOT EXISTS contactTable (id INTEGER PRIMARY KEY, name TEXT, mobileNumber TEXT, email TEXT, gender TEXT , address TEXT, photo TEXT)');
        });
  } else {

    database = await openDatabase(path);
    print("db Found");
  }
}