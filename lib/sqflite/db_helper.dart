// lib/sqflite/db_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yukmasak/model/Recipe.dart';
import 'package:yukmasak/model/user.dart';

class DbHelper {
  static Future<Database> databaseHelper() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'login.db'),
      onCreate: (db, version) async {
        // Method ini HANYA dijalankan saat database pertama kali dibuat
        // Buat semua tabel di sini
        await db.execute(
          // --- PERBAIKAN --- Menambahkan AUTOINCREMENT untuk ID yang dibuat otomatis oleh DB
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT, name TEXT)',
        );
        await db.execute(
          'CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, imagePath TEXT, isPremium INTEGER, ingredients TEXT, steps TEXT)',
        );
      },
      // --- PERBAIKAN --- Menambahkan callback onUpgrade untuk menangani perubahan skema
      onUpgrade: (db, oldVersion, newVersion) async {
        // Method ini akan dijalankan jika versi DB di kode lebih tinggi dari versi DB di perangkat
        if (oldVersion < 2) {
          // Jika versi lama adalah 1, berarti tabel 'recipes' belum ada, maka buat tabelnya
          await db.execute(
            'CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, imagePath TEXT, isPremium INTEGER)',
          );
        }
        // Jika nanti ada version 3, tambahkan logic di sini
        // if (oldVersion < 3) { ... }
      },
      version:
          3, // Naikkan versi ini setiap kali ada perubahan skema (tambah/ubah tabel/kolom)
    );
  }

  // ---------------- USER ----------------
  static Future<void> registerUser(User user) async {
    final db = await databaseHelper();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> loginUser(String email, String password) async {
    final db = await databaseHelper();
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // ... (method user lainnya tidak perlu diubah) ...

  // ---------------- RECIPE ----------------
  static Future<void> insertRecipe(Recipe recipe) async {
    final db = await databaseHelper();
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Recipe>> getAllRecipes() async {
    final db = await databaseHelper();
    final results = await db.query('recipes');
    return results.map((e) => Recipe.fromMap(e)).toList();
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    final db = await databaseHelper();
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteRecipe(int id) async {
    final db = await databaseHelper();
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}
