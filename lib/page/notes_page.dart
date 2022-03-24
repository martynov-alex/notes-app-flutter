import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:notes_app_sqflite/db/notes_database.dart';
import 'package:notes_app_sqflite/model/note.dart';
import 'package:notes_app_sqflite/page/note_detail_page.dart';
import 'package:notes_app_sqflite/widget/note_card_widget.dart';
import 'package:notes_app_sqflite/page/add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.closeDB();
    super.dispose();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(fontSize: 24)),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    'No notes',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black),
        //label: const Text('Add', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );
          refreshNotes();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigoAccent,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.star),
                color: Colors.yellow,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.square),
                color: Colors.lightGreen.shade300,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.square),
                color: Colors.lightBlue.shade300,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.square),
                color: Colors.orange.shade300,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.square),
                color: Colors.purpleAccent.shade100,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.square),
                color: Colors.redAccent.shade100,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  buildNotes() => MasonryGridView.count(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        NoteDetailPage(noteId: note.id!)),
              );
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
