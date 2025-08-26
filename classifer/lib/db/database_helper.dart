import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/officer.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('officers.db');
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
      CREATE TABLE officers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        empId TEXT NOT NULL
      )
    ''');

    // Insert sample officers
    await db.insert('officers', {'name': 'Ravi Kumar', 'empId': 'EMP001'});
    await db.insert('officers', {'name': 'Meena Sharma', 'empId': 'EMP002'});
    await db.insert('officers', {'name': 'Ajay Verma', 'empId': 'EMP003'});
  }

  Future<Officer?> getOfficer(String name, String empId) async {
    final db = await instance.database;
    final result = await db.query(
      'officers',
      where: 'name = ? AND empId = ?',
      whereArgs: [name, empId],
    );

    if (result.isNotEmpty) {
      return Officer.fromMap(result.first);
    } else {
      return null;
    }
  }
}
