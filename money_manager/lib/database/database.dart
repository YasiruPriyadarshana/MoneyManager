import 'package:money_manager/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CurrencyDatabase {
  Future<Database> createDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mmanager.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE expense (id INTEGER PRIMARY KEY, category TEXT, amount DOUBLE, unit TEXT, icon TEXT, date TEXT)');
    });
    return database;
  }

  Future<void> insertExpence(Expense expense) async {
    // Get a reference to the database.
    final db = await createDatabase();

    await db.insert(
      'expense',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExpence(int id) async {
    // Get a reference to the database.
    final db = await createDatabase();

    await db.delete(
      'expense',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Expense>> viewAllExpence() async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Query the table for all
    final List<Map<String, dynamic>> maps = await db.query('expense');

    // Convert the List<Map<String, dynamic> into a List.
    return List.generate(maps.length, (i) {
      return Expense(
        category: maps[i]['category'],
        amount: maps[i]['amount'],
        unit: maps[i]['unit'],
        icon: maps[i]['icon'],
        date: maps[i]['date'],
      );
    });
  }
}
