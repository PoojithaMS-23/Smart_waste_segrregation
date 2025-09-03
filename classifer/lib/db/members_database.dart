import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/members_model.dart';

class MemberDatabase {
  static final MemberDatabase instance = MemberDatabase._init();

  static Database? _database;

  MemberDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('members.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);

  return await openDatabase(
    path,
    version: 2, // increment this when you update schema
    onCreate: _createDB,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE members ADD COLUMN username TEXT');
        await db.execute('ALTER TABLE members ADD COLUMN password TEXT');
      }
    },
  );
}


  Future<void> _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE members (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      owner_name TEXT,
      door_number TEXT,
      area TEXT,
      district TEXT,
      pid TEXT,
      sas_id TEXT,
      points INTEGER DEFAULT 0,
      tax_amount REAL DEFAULT 0,
      tax_after_concession REAL DEFAULT 0,
      username TEXT,
      password TEXT
    )
  ''');
  }
  Future<Member?> getUserByUsernameAndPassword(String username, String password) async {
  final db = await instance.database;
  final result = await db.query(
    'members',
    where: 'username = ? AND password = ?',
    whereArgs: [username, password],
  );

  if (result.isNotEmpty) {
    return Member.fromMap(result.first);
  } else {
    return null;
  }
  }



  Future<int> insertMember(Member member) async {
    final db = await instance.database;
    return await db.insert('members', member.toMap());
  }

  Future<int> updateMember(Member member) async {
  final db = await instance.database;
  return db.update(
    'members',
    member.toMap(),
    where: 'id = ?',
    whereArgs: [member.id],
  );
}
Future<bool> usernameExists(String username) async {
  final db = await instance.database;
  final result = await db.query(
    'members',
    where: 'username = ?',
    whereArgs: [username],
  );
  return result.isNotEmpty;
}



  Future<Member?> getMemberBySasIdAndPid(String sasId, String pid) async {
  final db = await instance.database;
  final result = await db.query(
    'members',
    where: 'sas_id = ? AND pid = ?',
    whereArgs: [sasId, pid],
  );
  if (result.isNotEmpty) {
    return Member.fromMap(result.first);
  }
  return null;
}
Future<List<Member>> getMembersByDistrictAndArea(String district, String area) async {
  final db = await instance.database;
  final result = await db.query(
    'members',
    where: 'district = ? AND area = ?',
    whereArgs: [district, area],
  );
  return result.map((map) => Member.fromMap(map)).toList();
}

// Get distinct districts
Future<List<String>> getAllDistricts() async {
  final db = await instance.database;
  final result = await db.rawQuery('SELECT DISTINCT district FROM members');
  return result.map((row) => row['district'] as String).toList();
}

// Get distinct areas in a district
Future<List<String>> getAreasByDistrict(String district) async {
  final db = await instance.database;
  final result = await db.rawQuery(
    'SELECT DISTINCT area FROM members WHERE district = ?',
    [district],
  );
  return result.map((row) => row['area'] as String).toList();
}





  Future<List<Member>> getAllMembers() async {
    final db = await instance.database;
    final result = await db.query('members');
    return result.map((map) => Member.fromMap(map)).toList();
  }
  

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
