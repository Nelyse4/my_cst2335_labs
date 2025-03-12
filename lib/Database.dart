import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'Todo.dart';
import 'TodoDao.dart';
part 'Database.g.dart';

@Database(version: 1, entities: [Todo])
abstract class ToDoDatabase extends FloorDatabase {
  TodoDao get todoDao;
}