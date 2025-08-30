import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/officer.dart';
import '../models/members_model.dart';
import '../models/worker.dart';
import '../models/waste_item.dart';
import '../models/complaint.dart';
import '../models/feedback.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_waste.db');
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
    // Officers table
    await db.execute('''
      CREATE TABLE officers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        empId TEXT NOT NULL,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Members table
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
        tax_amount REAL DEFAULT 0.0,
        tax_after_concession REAL DEFAULT 0.0,
        username TEXT UNIQUE,
        password TEXT,
        house_type TEXT DEFAULT 'single',
        rental_count INTEGER DEFAULT 0
      )
    ''');

    // Workers table
    await db.execute('''
      CREATE TABLE workers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        workerId TEXT NOT NULL,
        area TEXT NOT NULL,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Waste items table
    await db.execute('''
      CREATE TABLE waste_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        image_path TEXT NOT NULL,
        classification TEXT NOT NULL,
        upload_date TEXT NOT NULL,
        is_correctly_segregated INTEGER DEFAULT 0,
        points_earned INTEGER,
        worker_feedback TEXT
      )
    ''');

    // Complaints table
    await db.execute('''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image_path TEXT,
        location TEXT,
        latitude REAL,
        longitude REAL,
        report_date TEXT NOT NULL,
        status TEXT DEFAULT 'pending',
        officer_response TEXT
      )
    ''');

    // Feedback table
    await db.execute('''
      CREATE TABLE feedback (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        rating INTEGER NOT NULL,
        submit_date TEXT NOT NULL,
        officer_response TEXT
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future _insertSampleData(Database db) async {
    // Sample officers
    await db.insert('officers', {
      'name': 'Ravi Kumar',
      'empId': 'EMP001',
      'username': 'ravi.kumar',
      'password': 'password123'
    });
    await db.insert('officers', {
      'name': 'Meena Sharma',
      'empId': 'EMP002',
      'username': 'meena.sharma',
      'password': 'password123'
    });

    // Sample members
    await db.insert('members', {
      'owner_name': 'John Doe',
      'door_number': 'A-101',
      'area': 'Downtown',
      'district': 'Central',
      'pid': 'PID001',
      'sas_id': 'SAS001',
      'points': 150,
      'tax_amount': 5000.0,
      'tax_after_concession': 4500.0,
      'username': 'john.doe',
      'password': 'password123',
      'house_type': 'single',
      'rental_count': 0
    });

    // Sample workers
    await db.insert('workers', {
      'name': 'Ram Singh',
      'age': 35,
      'gender': 'Male',
      'worker_id': 'WRK001',
      'area': 'Downtown',
      'username': 'ram.singh',
      'password': 'password123'
    });
  }

  // Officer methods
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

  Future<Officer?> getOfficerByUsername(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'officers',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return Officer.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Member methods
  Future<int> insertMember(Member member) async {
    final db = await instance.database;
    return await db.insert('members', member.toMap());
  }

  Future<List<Member>> getAllMembers() async {
    final db = await instance.database;
    final result = await db.query('members', orderBy: 'points DESC');
    return result.map((map) => Member.fromMap(map)).toList();
  }

  Future<Member?> getMemberByUsername(String username, String password) async {
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

  Future<void> updateMemberPoints(int memberId, int points) async {
    final db = await instance.database;
    await db.update(
      'members',
      {'points': points},
      where: 'id = ?',
      whereArgs: [memberId],
    );
  }

  Future<void> deleteMember(int memberId) async {
    final db = await instance.database;
    await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [memberId],
    );
  }

  // Worker methods
  Future<int> insertWorker(Worker worker) async {
    final db = await instance.database;
    return await db.insert('workers', worker.toMap());
  }

  Future<List<Worker>> getAllWorkers() async {
    final db = await instance.database;
    final result = await db.query('workers');
    return result.map((map) => Worker.fromMap(map)).toList();
  }

  Future<Worker?> getWorkerByUsername(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'workers',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return Worker.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> deleteWorker(int workerId) async {
    final db = await instance.database;
    await db.delete(
      'workers',
      where: 'id = ?',
      whereArgs: [workerId],
    );
  }

  // Waste item methods
  Future<int> insertWasteItem(WasteItem wasteItem) async {
    final db = await instance.database;
    return await db.insert('waste_items', wasteItem.toMap());
  }

  Future<List<WasteItem>> getWasteItemsByUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'waste_items',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'upload_date DESC',
    );
    return result.map((map) => WasteItem.fromMap(map)).toList();
  }

  Future<List<WasteItem>> getPendingWasteItems() async {
    final db = await instance.database;
    final result = await db.query(
      'waste_items',
      where: 'is_correctly_segregated = 0',
      orderBy: 'upload_date DESC',
    );
    return result.map((map) => WasteItem.fromMap(map)).toList();
  }

  Future<void> updateWasteItemFeedback(int wasteItemId, bool isCorrect, int points, String feedback) async {
    final db = await instance.database;
    await db.update(
      'waste_items',
      {
        'is_correctly_segregated': isCorrect ? 1 : 0,
        'points_earned': points,
        'worker_feedback': feedback,
      },
      where: 'id = ?',
      whereArgs: [wasteItemId],
    );
  }

  // Complaint methods
  Future<int> insertComplaint(Complaint complaint) async {
    final db = await instance.database;
    return await db.insert('complaints', complaint.toMap());
  }

  Future<List<Complaint>> getAllComplaints() async {
    final db = await instance.database;
    final result = await db.query('complaints', orderBy: 'report_date DESC');
    return result.map((map) => Complaint.fromMap(map)).toList();
  }

  Future<void> updateComplaintStatus(int complaintId, String status, String response) async {
    final db = await instance.database;
    await db.update(
      'complaints',
      {
        'status': status,
        'officer_response': response,
      },
      where: 'id = ?',
      whereArgs: [complaintId],
    );
  }

  // Feedback methods
  Future<int> insertFeedback(UserFeedback feedback) async {
    final db = await instance.database;
    return await db.insert('feedback', feedback.toMap());
  }

  Future<List<UserFeedback>> getAllFeedback() async {
    final db = await instance.database;
    final result = await db.query('feedback', orderBy: 'submit_date DESC');
    return result.map((map) => UserFeedback.fromMap(map)).toList();
  }

  Future<void> updateFeedbackResponse(int feedbackId, String response) async {
    final db = await instance.database;
    await db.update(
      'feedback',
      {'officer_response': response},
      where: 'id = ?',
      whereArgs: [feedbackId],
    );
  }

  // Analytics methods
  Future<Map<String, dynamic>> getAnalytics() async {
    final db = await instance.database;
    
    // Total waste items
    final wasteResult = await db.rawQuery('SELECT COUNT(*) as count FROM waste_items');
    final totalWaste = wasteResult.first['count'] as int;
    
    // Correctly segregated
    final correctResult = await db.rawQuery('SELECT COUNT(*) as count FROM waste_items WHERE is_correctly_segregated = 1');
    final correctWaste = correctResult.first['count'] as int;
    
    // Total complaints
    final complaintResult = await db.rawQuery('SELECT COUNT(*) as count FROM complaints');
    final totalComplaints = complaintResult.first['count'] as int;
    
    // Pending complaints
    final pendingResult = await db.rawQuery('SELECT COUNT(*) as count FROM complaints WHERE status = "pending"');
    final pendingComplaints = pendingResult.first['count'] as int;
    
    // Top areas by points
    final areaResult = await db.rawQuery('''
      SELECT area, SUM(points) as total_points 
      FROM members 
      GROUP BY area 
      ORDER BY total_points DESC 
      LIMIT 5
    ''');
    
    return {
      'totalWaste': totalWaste,
      'correctWaste': correctWaste,
      'totalComplaints': totalComplaints,
      'pendingComplaints': pendingComplaints,
      'topAreas': areaResult,
    };
  }
}
