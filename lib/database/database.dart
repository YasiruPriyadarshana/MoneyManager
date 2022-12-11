import 'package:money_manager/models/expense.dart';
import 'package:money_manager/models/income.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
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
          'CREATE TABLE expense (id INTEGER PRIMARY KEY, category TEXT, amount DOUBLE, icon INTEGER, date TEXT)');

      await db.execute(
          'CREATE TABLE income (id INTEGER PRIMARY KEY, category TEXT, amount DOUBLE, date TEXT)');
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

  Future<void> insertIncome(Income income) async {
    // Get a reference to the database.
    final db = await createDatabase();

    await db.insert(
      'income',
      income.toMap(),
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
        icon: maps[i]['icon'],
        date: maps[i]['date'],
      );
    });
  }

  Future<List<Income>> viewAllIncome() async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Query the table for all
    final List<Map<String, dynamic>> maps = await db.query('income');

    // Convert the List<Map<String, dynamic> into a List.
    return List.generate(maps.length, (i) {
      return Income(
        category: maps[i]['category'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }
}
