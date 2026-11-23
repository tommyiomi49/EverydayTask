import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Database helper implementing the exact ERD schema:
/// - Users (user_id PK, fName, lName, gmail, password)
/// - Subject (subject_id PK, user_id FK, subject_code, subject_name, instructor_name)
/// - Schoolwork (work_id PK, subject_id FK, title, description, due_date, due_time, priority, status)
class TaskTrackerDb {
  static final TaskTrackerDb instance = TaskTrackerDb._init();
  static Database? _database;

  TaskTrackerDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_tracker_academic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // Enable SQLite foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Users table (PK: user_id)
    await db.execute('''
      CREATE TABLE users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        fName TEXT NOT NULL,
        lName TEXT NOT NULL,
        gmail TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // 2. Subject table (PK: subject_id, FK: user_id)
    await db.execute('''
      CREATE TABLE subject (
        subject_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        subject_code TEXT NOT NULL,
        subject_name TEXT NOT NULL,
        instructor_name TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
      )
    ''');

    // 3. Schoolwork table (PK: work_id, FK: subject_id)
    await db.execute('''
      CREATE TABLE schoolwork (
        work_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT NOT NULL,
        due_time TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
      )
    ''');

    // Create indices for fast lookup
    await db.execute('CREATE INDEX idx_subject_user ON subject (user_id)');
    await db.execute('CREATE INDEX idx_schoolwork_subject ON schoolwork (subject_id)');

    // Seed realistic demo data so the app is ready for demonstration
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    // Demo user
    final userId = await db.insert('users', {
      'fName': 'Alex',
      'lName': 'Morales',
      'gmail': 'alex.morales@gmail.com',
      'password': 'password123',
    });

    // Demo subjects
    final subj1 = await db.insert('subject', {
      'user_id': userId,
      'subject_code': 'CS301',
      'subject_name': 'Data Structures and Algorithms',
      'instructor_name': 'Prof. Emily Chen',
    });

    final subj2 = await db.insert('subject', {
      'user_id': userId,
      'subject_code': 'MATH202',
      'subject_name': 'Discrete Mathematics',
      'instructor_name': 'Dr. Robert Santos',
    });

    final subj3 = await db.insert('subject', {
      'user_id': userId,
      'subject_code': 'IT215',
      'subject_name': 'Database Management Systems',
      'instructor_name': 'Engr. Sarah Jenkins',
    });

    final subj4 = await db.insert('subject', {
      'user_id': userId,
      'subject_code': 'ENG102',
      'subject_name': 'Technical Report Writing',
      'instructor_name': 'Ms. Laura Davis',
    });

    // Helper to format date offset
    final now = DateTime.now();
    String formatDate(DateTime dt) {
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    }

    final todayStr = formatDate(now);
    final tomorrowStr = formatDate(now.add(const Duration(days: 1)));
    final inThreeDaysStr = formatDate(now.add(const Duration(days: 3)));
    final nextWeekStr = formatDate(now.add(const Duration(days: 7)));
    final yesterdayStr = formatDate(now.subtract(const Duration(days: 1)));

    // Demo schoolworks
    await db.insert('schoolwork', {
      'subject_id': subj1,
      'title': 'Binary Search Tree Implementation',
      'description': 'Implement insertion, deletion, and in-order traversal in C++ or Java with full test cases.',
      'due_date': todayStr,
      'due_time': '23:59',
      'priority': 'High',
      'status': 'Pending',
    });

    await db.insert('schoolwork', {
      'subject_id': subj3,
      'title': 'ERD Diagram and Normalization Case Study',
      'description': 'Design ERD for University Enrollment System and normalize tables up to 3NF.',
      'due_date': tomorrowStr,
      'due_time': '17:00',
      'priority': 'High',
      'status': 'In Progress',
    });

    await db.insert('schoolwork', {
      'subject_id': subj2,
      'title': 'Problem Set 4: Graph Theory & Trees',
      'description': 'Answer exercises 1 to 15 on Euler circuits and Hamiltonian paths.',
      'due_date': inThreeDaysStr,
      'due_time': '12:00',
      'priority': 'Medium',
      'status': 'Pending',
    });

    await db.insert('schoolwork', {
      'subject_id': subj4,
      'title': 'Project Proposal Draft',
      'description': 'Submit 3-page draft of academic project proposal with literature review citations.',
      'due_date': nextWeekStr,
      'due_time': '23:59',
      'priority': 'Medium',
      'status': 'Pending',
    });

    await db.insert('schoolwork', {
      'subject_id': subj1,
      'title': 'Quiz 2 Review Notes',
      'description': 'Review sorting algorithms: QuickSort, MergeSort, and HeapSort time complexities.',
      'due_date': yesterdayStr,
      'due_time': '10:00',
      'priority': 'Low',
      'status': 'Completed',
    });
  }

  /// Resets the database and reseeds demo data
  Future<void> resetAndReseed() async {
    final db = await database;
    await db.delete('schoolwork');
    await db.delete('subject');
    await db.delete('users');
    await _seedInitialData(db);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

