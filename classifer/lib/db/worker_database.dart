import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/worker.dart';

class WorkerDatabase {
  static final WorkerDatabase instance = WorkerDatabase._init();

  static Database? _database;

  WorkerDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('workers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE workers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      age INTEGER NOT NULL,
      gender TEXT NOT NULL,
      workerId TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertWorker(Worker worker) async {
    final db = await instance.database;
    return await db.insert('workers', worker.toMap());
  }

  Future<List<Worker>> getAllWorkers() async {
    final db = await instance.database;
    final result = await db.query('workers');

    return result.map((map) => Worker.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
