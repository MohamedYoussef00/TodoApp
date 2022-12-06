
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/cubit/status.dart';
import 'package:sqflite/sqflite.dart';

import '../components/constants.dart';
import '../modules/archived_tasks/archived_tasks_screan.dart';
import '../modules/done_tasks/done_tasks_screan.dart';
import '../modules/new_tasks/new_tasks_screan.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TodoCubit extends Cubit<TodoStatus>{

  TodoCubit() : super(InitialTodoStatus());

  static TodoCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screans = [
    NewTasksScrean(),
    DoneTasksScrean(),
    ArchivedTasksScrean()
  ];

  List<String> appBarName = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void ChangIndex( int index){
    currentIndex =index;
    emit(ChangeNavBarStatus());
  }


  Database database;
  void creatDataBase()
  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (Database database, int version) async {
          // When creating the db, create the table
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, data TEXT, status TEXT)'
          );
        },
        onOpen: (database){
          getDataFromDatabase(database);
        },
    ).then((value)  {
      database=value;
      emit(CreateDatabaseStatus());
    }
    );
  }

  inseartInToDatabase(
      @required String title,
      @required String time,
      @required String data
      )async
  {

    await database.transaction((txn)
    {
      txn.rawInsert(
          'INSERT INTO tasks (title, time, data,status) VALUES("$title", "$time", "$data" ,"new")'
      ).then((value)
      {
        print ('$value ');
        emit(InsertDatabaseStatus());
        getDataFromDatabase(database);
      }
      ).catchError(
              (error){print('errrror'+error.toString());});
      /*  txn.rawInsert(
          'INSERT INTO tasks (title, time, data,status) VALUES(?, ?, ?,?)',
          ['another name', '12345678', '3.1416','new']);*/
    });

  }

  List<Map>newTasksList=[];
  List<Map>doneTasksList=[];
  List<Map>archiveTasksList=[];
  List<tz.TZDateTime>taskesTime=[];
  void getDataFromDatabase(database)
  {
    newTasksList=[];
    doneTasksList=[];
    archiveTasksList=[];
    taskesTime=[];
    emit(GetDatabaseLodingStatus());
    //await Future.delayed(Duration(seconds: 10));
    print('ingeeeeeeeteeeeeeeeeeeeeeeeeeeeeeee');
    tz.initializeTimeZones();
    database.rawQuery('SELECT * FROM tasks').then((value){
        value.forEach((element){

          print(new DateFormat('MMM dd, yyy hh:mm aaa').parse(element['data']+' '+element['time']));
          DateTime dateTime=new DateFormat('MMM dd, yyy hh:mm aaa').parse(element['data']+' '+element['time']);
        //  tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);
         // taskesTime.add(scheduledAt);
        if(element['status']=='new'){
          print('fffffffffffffffffffffffffffffffffffffinnnnnnnnnnnnnnnnnnnn');

          newTasksList.add(element);
          tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);
          taskesTime.add(scheduledAt);
        }
        else if(element['status']=='done')
          doneTasksList.add(element);
        else archiveTasksList.add(element);
      });
        emit(GetDatabaseStatus());
    });

  }


  bool bottomSheetIsShown = false;
  IconData FABIcon=Icons.edit;

  void changeBottomSheetStatus(
      @required bool BtSheetShown,
      @required IconData fabIcon
      )
  {
    bottomSheetIsShown=BtSheetShown;
    FABIcon=fabIcon;
    emit(ChangeBtmSheetStatus());

  }

  void updateInDatabase(
      @required int id,
      @required String value
      ){
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id= ?', ['$value',id]
    ).then((value) {
      emit(UpdateDatabaseStatus());
      getDataFromDatabase(database);
    });
   // print('updated: $count');
  }

  void deleteFromDatabase(
      @required int id,
      ){
    database.rawUpdate(
        'DELETE FROM tasks  WHERE id= ?', [id]
    ).then((value) {
      emit(DeletFromDatabaseStatus());
      getDataFromDatabase(database);
    });
  }
}