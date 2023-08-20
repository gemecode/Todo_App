import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/controllers/states.dart';
import 'package:todo_app/views/pages/archive_task_page.dart';
import 'package:todo_app/views/pages/done_task_page.dart';
import 'package:todo_app/views/pages/new_task_page.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  List<Widget> pages = [
    const NewTaskPage(),
    const DoneTaskPage(),
    const ArchiveTaskPage()
  ];

  List<String> labels = [
    "New Task",
    "Done Task",
    "Archive Task"
  ];


  //database
  late Database database;
  // List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var fromKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();




  //app functions

  int currentIndex = 0;
  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNaveBarState());
  }


  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon
  }){
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }


  void createDatabase() {
    openDatabase("todo.db", version: 2,
        onCreate: (database, version) {
          print("database created");
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print("table created");
          }).catchError((error) {
            print("Error When Creating Table : ${error.toString()}");
          });
        }, onOpen: (database) {
          print("database opened");
          gitDataFromDatabase(database);
        }).then((value){
          database = value;
          emit(AppCreateDatabaseState());
    });
  }

  void gitDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value){
      // print(value);
      value.forEach((element){
        if(element['status'] == "new"){
          newTasks.add(element);
        }else if(element['status'] == "done"){
          doneTasks.add(element);
        }else{
          archiveTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  insertToDatabase(
      {
        required String title,
        required String date,
        required String time}
      ) async {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        gitDataFromDatabase(database);

      }).catchError((error) {
        print("Error When Inserting New Record : ${error.toString()}");
      });
      return Future(() => null);
    });
  }



  void updateData({
    required String status,
    required int id,
  }){
    database.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    [status, '$id']).then((value){
      gitDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }



  void deleteData({
    required int id,
  }){
    database.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      gitDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


}