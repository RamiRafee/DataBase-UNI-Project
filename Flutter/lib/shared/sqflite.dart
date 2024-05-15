import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb{
  static Database? _db ;
  Future<Database?> get db async {
    if(_db == null){
      _db = await initialDb();
      return _db;
    }else {
      return _db;
    }
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database myDb = await openDatabase(path , onCreate: _onCreate ,version: 1,onUpgrade: _onUpgrade ,onOpen: _onOpen);
    return myDb;
  }
  _onCreate (Database db , int version) async{
      await db.execute('''
      CREATE TABLE "notes" ("id" INTEGER PRIMARY KEY ,
      "title" TEXT NOT NULL, date TEXT NOT NULL )
      ''');
      if (kDebugMode) {
        print('data base created');
      }
  }
  _onUpgrade(Database db , int version , int newVersion){

  }
  _onOpen(Database db){
    if (kDebugMode) {
      print('database opened');
    }
  }

  readData(String sql) async{
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }
  insertData(String sql) async{
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql);
    return response;
  }
  updateData(String sql) async{
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }
  deleteData(String sql) async{
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql);
    return response;
  }



}