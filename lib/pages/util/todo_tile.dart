import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String noteName;
  final bool noteDone;
  final Function(bool?)? _onChanged;
  Function(BuildContext)? deleteFunction;

  TodoTile({
    super.key,
    required this.noteName,
    required this.noteDone,
    required this._onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: noteDone
                ? const Color.fromARGB(255, 194, 255, 89)
                : Colors.amber,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Checkbox(
                value: noteDone,
                onChanged: _onChanged,
                activeColor: const Color.fromARGB(255, 49, 49, 49),
              ),
              Text(
                noteName,
                style: TextStyle(
                  decoration: noteDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
