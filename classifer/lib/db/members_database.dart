import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

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
      version: 3, // increment this when you update schema
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          try {
            await db.execute('ALTER TABLE members ADD COLUMN username TEXT');
          } catch (_) {}
          try {
            await db.execute('ALTER TABLE members ADD COLUMN password TEXT');
          } catch (_) {}
        }
        if (oldVersion < 3) {
          try {
            await db.execute(
              "ALTER TABLE members ADD COLUMN house_type TEXT CHECK(house_type IN ('commercial', 'semi-commercial', 'non commercial'))",
            );
          } catch (_) {}
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE members (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      owner_name TEXT NOT NULL,
      door_number TEXT NOT NULL,
      area TEXT NOT NULL,
      district TEXT NOT NULL,
      pid TEXT NOT NULL,
      sas_id TEXT NOT NULL,
      points INTEGER DEFAULT 0,
      tax_amount REAL DEFAULT 0,
      tax_after_concession REAL DEFAULT 0,
      username TEXT UNIQUE,
      password TEXT,
      house_type TEXT CHECK(house_type IN ('commercial', 'semi-commercial', 'non commercial'))
    )
    ''');
  }

  /// Hash password using SHA-256 (simple example)
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Member?> getUserByUsernameAndPassword(String username, String password) async {
    final db = await instance.database;
    final hashedPassword = hashPassword(password);
    final result = await db.query(
      'members',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (result.isNotEmpty) {
      return Member.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> insertMember(Member member) async {
    final db = await instance.database;
    final memberMap = member.toMap();

    // Hash password if provided
    if (member.password != null) {
      memberMap['password'] = hashPassword(member.password!);
    }

    return await db.insert('members', memberMap);
  }

  Future<int> updateMember(Member member) async {
  if (member.id == null) {
    throw ArgumentError('Member id cannot be null for update');
  }

  final db = await instance.database;
  final memberMap = member.toMap();

  // Fetch existing password and username from DB
  final existing = await db.query(
    'members',
    columns: ['password', 'username'],
    where: 'id = ?',
    whereArgs: [member.id],
  );

  String? existingPassword = existing.isNotEmpty ? existing.first['password'] as String? : null;
  String? existingUsername = existing.isNotEmpty ? existing.first['username'] as String? : null;

  // Preserve password if null or empty
  if (member.password == null || member.password!.isEmpty) {
    memberMap['password'] = existingPassword;
  } else {
    memberMap['password'] = hashPassword(member.password!);
  }

  // Preserve username if null or empty
  if (member.username == null || member.username!.isEmpty) {
    memberMap['username'] = existingUsername;
  } else {
    memberMap['username'] = member.username;
  }

  return db.update(
    'members',
    memberMap,
    where: 'id = ?',
    whereArgs: [member.id],
  );
}

Future<int> updateMemberPointsAndTax(int id, int points, double taxAfterConcession) async {
  final db = await instance.database;

  return await db.update(
    'members',
    {
      'points': points,
      'tax_after_concession': taxAfterConcession, // ✅ correct column name
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}



Future<Member?> getMemberBySasId(String sasId) async {
  final db = await instance.database;
  final maps = await db.query(
    'members',
    where: 'sasId = ?',
    whereArgs: [sasId],
  );

  if (maps.isNotEmpty) {
    return Member.fromMap(maps.first);
  } else {
    return null;
  }
}





  Future<Member?> getMemberByUsername(String username) async {
  final db = await instance.database;
  final maps = await db.query(
    'members',
    where: 'username = ?',
    whereArgs: [username],
  );
  if (maps.isNotEmpty) {
    return Member.fromMap(maps.first);
  }
  return null;
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
    await db.close();
  }
}
