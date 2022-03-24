import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_sqflite/model/note.dart';

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final time = DateFormat('EEE, d MMM, y').format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: cardColor(note.number),
      child: Container(
        constraints: BoxConstraints(minHeight: 75),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      Text(time, style: TextStyle(color: Colors.grey.shade700)),
                ),
                Text(note.isImportant ? '⭐' : ''),
              ],
            ),
            SizedBox(height: 4),
            Text(
              note.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }

  Color cardColor(num number) {
    switch (number.toInt()) {
      case 0:
        return Colors.lightGreen.shade300;
      case 1:
        return Colors.lightBlue.shade300;
      case 2:
        return Colors.orange.shade300;
      case 3:
        return Colors.purpleAccent.shade100;
      case 4:
        return Colors.redAccent.shade100;
      default:
        return Colors.white;
    }
  }
}
