import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../features/home/models/sample_json.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

   String tableProduct = "tbl_product";
  String tableWishlist = "tbl_wishlist";

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'shopping_cart.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await createCartTable(db);
          await createWishlistTable(db);
          await createProductTable(db);
        });
  }

  Future<void> createCartTable(Database db) async {
    await db.execute('''
      CREATE TABLE Cart (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT
      )
    ''');
  }

  Future<void> createWishlistTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableWishlist (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT
      )
    ''');
  }

  Future<void> createProductTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableProduct (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT
      )
    ''');
  }

  Future<void> createProduct(List<Shopping> newShoppingList) async {
    await deleteAllProducts();
    final db = await database;
    for (int i = 0; i < newShoppingList.length; i++) {
      final res = await db?.insert(tableProduct, newShoppingList[i].toJson());
      // Handle the result if needed
    }
  }

  Future<void> createProductWishlist(Shopping newShoppingItem) async {
    final db = await database;
    final res = await db?.insert(tableWishlist, newShoppingItem.toJson());
    // Handle the result if needed
  }

  Future<int> deleteAllProducts() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM $tableProduct');
    return res ?? 0;
  }

  Future<List<Shopping>> getAllProducts() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM $tableProduct");
    List<Shopping> list = res!.isNotEmpty
        ? res.map((c) => Shopping.fromJson(c)).toList().cast<Shopping>()
        : [];
    return list;
  }

  Future<List<Shopping>> getAllWishlistItems() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM $tableWishlist");
    List<Shopping> list = res!.isNotEmpty
        ? res.map((c) => Shopping.fromJson(c)).toList().cast<Shopping>()
        : [];
    return list;
  }

  Future<int> deleteWishlistItem(String id) async {
    final db = await database;
    final res = await db?.delete(tableWishlist, where: 'id = ?', whereArgs: [id]);
    return res ?? 0;
  }
}