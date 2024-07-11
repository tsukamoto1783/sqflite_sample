import 'package:flutter/widgets.dart';

import 'dog_model.dart';
import 'sqflite_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = SqfliteHelper();
  await db.initDatabase();

  // 検証1：テーブルからすべてのdogsを取得しても、初期化後すぐなのでテーブルが空であることを確認。
  print(await db.getDogs());

  // 適当なDog（fido）を作成し、テーブルに追加。
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );
  await db.insertDog(fido);

  // 検証2：テーブルからすべてのdogsを取得し、テーブルに追加されたことを確認。
  print(await db.getDogs());

  // fido のageを更新し、DBに保存。
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await db.updateDog(fido);

  // 検証3：テーブルからすべてのdogsを取得し、fidoのageが更新されていることを確認。
  print(await db.getDogs());

  // fidoをDBから削除。
  await db.deleteDog(fido.id);

  // 検証4：テーブルからすべてのdogsを取得し、fidoが削除されていることを確認。
  print(await db.getDogs());
}
