import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/patient.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medical_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        nom TEXT,
        prenom TEXT,
        telephone TEXT,
        email TEXT,
        adresse TEXT,
        lastModified TEXT
      )
    ''');
  }

  Future<void> insertPatient(Patient patient) async {
    final db = await database;
    await db.insert('patients', patient.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Patient>> getAllPatients() async {
    final db = await database;
    final result = await db.query('patients');
    return result.map((e) => Patient.fromMap(e)).toList();
  }

  Future<void> deletePatient(String id) async {
    final db = await database;
    await db.delete('patients', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isPhoneOrEmailTaken(String phone, String email) async {
    final db = await database;
    final result = await db.query(
      'patients',
      where: 'telephone = ? OR email = ?',
      whereArgs: [phone, email],
    );
    return result.isNotEmpty;
  }

  Future<void> updatePatient(Patient patient) async {
    final db = await database;
    await db.update(
      'patients',
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }
}