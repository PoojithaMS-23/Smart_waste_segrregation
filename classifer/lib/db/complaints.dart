import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ComplaintDatabase {
  static final ComplaintDatabase instance = ComplaintDatabase._init();

  static Database? _database;

  ComplaintDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('complaints.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const complaintTable = '''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        complainant_username TEXT NOT NULL,
        message TEXT NOT NULL,
        against TEXT,
        timestamp TEXT NOT NULL
      )
    ''';

    await db.execute(complaintTable);
  }

  Future<int> insertComplaint(Map<String, dynamic> complaint) async {
    final db = await instance.database;
    return await db.insert('complaints', complaint);
  }

  Future<List<Map<String, dynamic>>> getAllComplaints() async {
    final db = await instance.database;
    return await db.query('complaints', orderBy: 'timestamp DESC');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
