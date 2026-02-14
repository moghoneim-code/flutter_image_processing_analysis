import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../features/home/data/models/history_model.dart';
import '../../errors/failures.dart';
import 'app_database.dart';

class SqliteDatabaseImpl implements AppDatabase {
  Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'imageflow_history.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT NOT NULL,
            result TEXT NOT NULL,
            dateTime TEXT NOT NULL,
            type TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<int> insert(HistoryModel history) async {
    if (_db == null) await init();
    return await _db!.insert(
      'history',
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<HistoryModel>> getAll() async {
    try {
      if (_db == null) await init();
      final List<Map<String, dynamic>> maps =
      await _db!.query('history', orderBy: 'id DESC');
      return maps.map((map) => HistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw const DatabaseFailure("Failed to load history from device.");
    }
  }

  @override
  Future<int> delete(int id) async {
    if (_db == null) await init();
    return await _db!.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}