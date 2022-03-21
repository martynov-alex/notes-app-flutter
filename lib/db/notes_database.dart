import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:notes_app_sqflite/model/note.dart';

class NotesDatabase {
  // Приватный конструктор, теперь можно обращаться к методам класса не создавая
  // объекты
  NotesDatabase._();

  // Создаем объект внутри класса
  static final NotesDatabase instance = NotesDatabase._();

  // Объект SQLFlite
  static Database? _database;

  // Создаем геттер для подключения к базе
  Future<Database> get database async {
    // Если существует подключение, то возвращаем
    if (_database != null) return _database!;
    // Если нет, инициализируем
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Определяем путь до места хранения БД
    // Для Андроид data/data//databases
    final dbPath = await getDatabasesPath();
    // Для iOS можно также использовать path_provider
    // final dbPathIos = await getLibraryDirectory();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Если база не существует, то создается по такой схеме
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes (
  ${NoteFields.id} $idType,
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType
  )
'''); // Обрати внимание на отсутствие запятой после последнего параметра!!!
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;

    // Этот код делает тоже самое, что и код ниже
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO $tableNotes ($columns) VALUES ($values)');

    // После вставки записи, метод возвращает id, который мы записываем
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      // Можно было бы '... = $id', но это небезопасно, т.е. дает возможность
      // свершитьь SQL injection attack
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
      // Если несколько аргументов, то и вопросов столько же [id, value] => ? ?
    );

    if (maps.isNotEmpty) {
      // db.query возвращает List<Map<String, Object?>>, но нам нужен только 1
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDERED BY $orderBy');

    // Без дополнительных аргументов query возвращает все записи в таблице
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    // db.rawUpdate(sql)
    return await db.update(
      tableNotes,
      note.toJson(),
      where: '{$NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    // db.rawDelete(sql)
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDB() async {
    // Подключаемся к базе через геттер
    final db = await instance.database;
    // Закрываем базу
    db.close();
  }
}
