import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dog_model.dart';

/// シングルトンクラス
class SqfliteHelper {
  static final SqfliteHelper _instance = SqfliteHelper._internal();

  factory SqfliteHelper() {
    return _instance;
  }

  SqfliteHelper._internal();

  Database? _database;

  /// データベースを初期化するメソッド
  Future<void> initDatabase() async {
    if (_database != null) return;

    // デフォルトのDB保存用フォルダのパスを取得
    final databasesPath = await getDatabasesPath();

    // データベースへのパスを設定する。
    // 注: `path` パッケージの `join` 関数を使用するのがベストプラクティス。と記載あり。
    final path = join(databasesPath, "doggie_database.db");

    // スキーマバージョンを設定。
    const schemaVersion = 1;

    _database = await openDatabase(
      path,
      version: schemaVersion,
      // DBがpathに存在しない場合、onCreateが呼び出されてテーブルを作成する。
      onCreate: (db, version) {
        // データベース上でCREATE TABLE文を実行する。
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
    );
  }

  /// 新しいdogをデータベースに挿入するメソッド。
  Future<void> insertDog(Dog dog) async {
    await _database!.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // 二度目の挿入時には、以前のデータを置き換える設定。
    );
  }

  /// dogsテーブルからすべてのdogsを取得するメソッド。
  Future<List<Dog>> getDogs() async {
    // すべてのdogsテーブルを照会する。
    final List<Map<String, Object?>> dogMaps = await _database!.query('dogs');

    // 各dogフィールドのリストを `Dog` オブジェクトのリストに変換して返却。
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  /// 指定Dogを更新するメソッド。
  Future<void> updateDog(Dog dog) async {
    await _database!.update(
      'dogs',
      dog.toMap(),
      // dogのidが一致することを確認。
      where: 'id = ?',
      // SQLインジェクションを防ぐために、dogのidをwhereArgとして渡す。
      whereArgs: [dog.id],
    );
  }

  /// Dogを削除するメソッド。
  Future<void> deleteDog(int id) async {
    await _database!.delete(
      'dogs',
      // 特定のdogを削除するには、`where`句を使う。
      where: 'id = ?',
      // SQLインジェクションを防ぐために、dogのidをwhereArgとして渡す。
      whereArgs: [id],
    );
  }
}
