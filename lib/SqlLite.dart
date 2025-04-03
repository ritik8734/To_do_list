import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Bloc/model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'employees.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            role TEXT,
            startDate TEXT,
            endDate TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    int result = await db.insert('employees', employee.toMap());
    print(
      "Inserted Employee ID: $result",
    ); // ✅ Check if insertion was successful
    return result;
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');

    List<Employee> employees = List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });

    print("Fetched Employees: ${employees.length}"); // ✅ Debugging check
    return employees;
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
