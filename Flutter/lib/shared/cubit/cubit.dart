import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:e_commerce_app/shared/cubit/states.dart';
import 'package:e_commerce_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super (AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  static Database? _db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  int currentIndex = 0;
  List<Widget> screens = [

  ];
  List<String> titles = [

  ];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

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
    String path =  join(databasePath, 'todo.db');
    Database myDb = await openDatabase(path , onCreate:  _onCreate ,version: 1,onOpen:  _onOpen , onUpgrade: _onUpgrade);
    return myDb;
  }

  _onCreate (Database db , int version) {
     db.execute('''
      CREATE TABLE "task" ("id" INTEGER PRIMARY KEY ,
      "title" TEXT NOT NULL, 
      "date" TEXT NOT NULL ,
      "time" TEXT NOT NULL, 
      "status" TEXT NOT NULL)
      ''').then((value) {
        emit(AppCreateDatabaseState());
     });
    if (kDebugMode) {
      print('database created ###########################################');
    }
  }
  _onUpgrade(Database db , int version , int newVersion){}
  _onOpen(Database db){
    readData();
    if (kDebugMode) {
      print('database opened ###########################################');
      print('new tasks $newTasks');
      print('done tasks $doneTasks');
      print('archived tasks $archivedTasks');
    }
  }

  readData() async{
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppReadDatabaseLoadingState());
    Database? myDb = await db;

    myDb!.rawQuery("SELECT * FROM 'task'").then((value){
      if (kDebugMode) {
        print('in reading state ##########################');
      }

      for (var element in value) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if (element['status'] == 'done'){
          doneTasks.add(element);
        }
        else { //else if (element['status'] == 'archived')
          archivedTasks.add(element);
        }
      }
      if (kDebugMode) {
        print('new tasks $newTasks');
        print('done tasks $doneTasks');
        print('archived tasks $archivedTasks');
      }

      emit(AppReadDatabaseState());
    });
  }
  insertData({required String title, required String time, required String date,}) async{
    Database? myDb = await db;
    myDb!.rawInsert(
        "INSERT INTO 'task'('title' , 'date' , 'time' , 'status') VALUES('$title' , '$date' , '$time' , 'new')"
    ).then((value){
      if (kDebugMode) {
        print('$value inserted successfully');
      }
      emit(AppInsertDatabaseState());
      readData();
    });
    if (kDebugMode) {
      print('data inserted ##################################');
    }
  }

  updateData({required String status , required int id}) async{
    Database? myDb = await db;
    myDb!.rawUpdate("UPDATE 'task' SET 'status' = ? WHERE 'id' = ?",[status , id]).then((value) {

      readData();
      emit(AppUpdateDatabaseState());
    });
    if (kDebugMode) {
      print('data updated #####################################');
    }
  }
  deleteData({required int id}) async{
    Database? myDb = await db;
    myDb!.rawDelete("DELETE FROM 'task' WHERE 'id' = ?",[id]).then((value) {
      readData();
    });
    if (kDebugMode) {
      print('data deleted ##################################');
    }
  }

  void changeBottomSheetState({required bool isShow, required IconData icon,required context}){
    if(isShow){
      Navigator.pop(context);
    }
    isBottomSheetShown = isShow;
    fabIcon = icon ;

    emit(AppChangeBottomSheetState());
  }


  bool isDark = false ;

  void changeDarkMode([bool? dark]){
    if(dark != null){
      isDark = dark;
      emit(AppChangeDarkState());
    }
    else {
      isDark = !isDark;
      CacheHelper.putBool(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeDarkState());
      });
    }
  }
}