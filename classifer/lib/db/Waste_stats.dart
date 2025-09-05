import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WasteStatsDatabase {
  static final WasteStatsDatabase instance = WasteStatsDatabase._init();

  static Database? _database;

  WasteStatsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('waste_stats.db');
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
      CREATE TABLE waste_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        district TEXT NOT NULL,
        area TEXT NOT NULL,
        correct_points INTEGER DEFAULT 0,
        incorrect_points INTEGER DEFAULT 0,
        UNIQUE(district, area)
      )
    ''');
  }

  Future<void> incrementCorrectPoints(String district, String area, int incrementBy) async {
    final db = await instance.database;

    await db.rawInsert('''
      INSERT OR IGNORE INTO waste_stats (district, area, correct_points, incorrect_points)
      VALUES (?, ?, 0, 0)
    ''', [district, area]);

    await db.rawUpdate('''
      UPDATE waste_stats
      SET correct_points = correct_points + ?
      WHERE district = ? AND area = ?
    ''', [incrementBy, district, area]);
  }

  Future<void> incrementIncorrectPoints(String district, String area, int incrementBy) async {
    final db = await instance.database;

    await db.rawInsert('''
      INSERT OR IGNORE INTO waste_stats (district, area, correct_points, incorrect_points)
      VALUES (?, ?, 0, 0)
    ''', [district, area]);

    await db.rawUpdate('''
      UPDATE waste_stats
      SET incorrect_points = incorrect_points + ?
      WHERE district = ? AND area = ?
    ''', [incrementBy, district, area]);
  }

  Future<List<Map<String, dynamic>>> getAllAreaStats() async {
    final db = await instance.database;
    return await db.query('waste_stats');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
