import 'package:sqflite/sqflite.dart';
import 'package:timely_medicine/addMedForm.dart';
import 'package:path/path.dart';

class MedicineDB {
  static final MedicineDB instance = MedicineDB._init();
  static Database? _database;
  MedicineDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("medicines.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE medicines(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dosage TEXT,
        name TEXT NOT NULL,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL
        )
''');
      },
    );
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final db = await instance.database;
    return await db.insert('medicines', medicine.toMap());
  }

  Future<List<Medicine>> getAllMedicines() async {
    final db = await instance.database;
    final result = await db.query('medicines');
    return result.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<int> deleteMedicine(int id) async {
    final db = await instance.database;
    return await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }
}
