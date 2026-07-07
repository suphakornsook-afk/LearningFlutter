import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/note_data.dart';
import 'package:flutter_application_2/pages/util/dialog_box.dart';
import 'package:flutter_application_2/pages/util/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  //Using Hive for Local Storage
  final _noteBox = Hive.box("noteBox");

  final _controller = TextEditingController();

  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_noteBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  //save new note
  void saveNewNote() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewNote,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteNote(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //transparent appbar
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("To Do App", style: TextStyle(color: Colors.black)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewNote,
        child: Icon(Icons.add),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 247, 245, 222),
              Color.fromARGB(255, 248, 245, 96),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return TodoTile(
              noteName: db.toDoList[index][0],
              noteDone: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteNote(index),
            );
          },
        ),
      ),
    );
  }
}
