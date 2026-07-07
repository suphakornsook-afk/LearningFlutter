import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  final _noteBox = Hive.box('noteBox');

  //first time opening this
  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Second Tutorial", true],
    ];
  }

  void loadData() {
    toDoList = _noteBox.get("TODOLIST");
  }

  void updateDataBase() {
    _noteBox.put("TODOLIST", toDoList);
  }
}
