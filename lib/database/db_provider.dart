import 'package:path/path.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../features/home/models/sample_json.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'shopping_cart.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Shopping('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'description TEXT,'
          'price REAL,'
          'imageUrl TEXT'
          ')');
    });
  }

  createProduct(List<Shopping> newShoppingList) async {
    await deleteAllProducts();
    final db = await database;
    for (int i = 0; i < newShoppingList.length; i++) {
      final res = await db?.insert('Shopping', newShoppingList[i].toJson());
      // Handle the result if needed
    }
  }


  Future<int> deleteAllProducts() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM Shopping');
    return res ?? 0;
  }

  Future<List<Shopping>?> getAllProducts() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM Shopping");
    List<Shopping>? list = res!.isNotEmpty
        ? res.map((c) => Shopping.fromJson(c)).toList().cast<Shopping>()
        : [];
    return list;
  }
}
