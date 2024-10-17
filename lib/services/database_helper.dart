import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cotizacion.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'cotizaciones.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE cotizaciones(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            senores TEXT,
            nit TEXT,
            telefono TEXT,
            direccion TEXT,
            numeroCotizacion INTEGER,
            fecha TEXT,
            items TEXT // Puedes almacenar los ítems como JSON si es necesario
          )
        ''');
      },
    );
  }

  Future<void> insertCotizacion(Cotizacion cotizacion) async {
    final db = await database;
    await db.insert(
      'cotizaciones',
      cotizacion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cotizacion>> getCotizaciones() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cotizaciones');

    return List.generate(maps.length, (i) {
      return Cotizacion.fromMap(maps[i]);
    });
  }
}
