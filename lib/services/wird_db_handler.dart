import 'package:flutter_sqlite_demo/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WirdDatabaseHelper {
  static final WirdDatabaseHelper _instance = WirdDatabaseHelper._internal();
  static Database? _database;

  factory WirdDatabaseHelper() {
    return _instance;
  }

  WirdDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wird_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE wird(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            createdDate TEXT,
            currentWird INTEGER,
            status TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  // Insert a new user
  Future<int> insertWird(User user) async {
    final db = await database;
    return await db.insert('wird', user.toMap());
  }

  // Retrieve all users
  Future<List<User>> getWirds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wird');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  void printUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wird');
    List<User> users = List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
    // print in table format
    print('ID\tName\tAge');
    print('----------------');
    for (var user in users) {
      print('${user.id}\t${user.name}\t${user.age}');
    }
  }
  

  // Update a user
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'wird',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete a user
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'wird',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}