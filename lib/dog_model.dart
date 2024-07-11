class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // DogをMapに変換する。キーはデータベースのカラム名に対応しなければならない。
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // printステートメントを使用する際に、それぞれの犬に関する情報を簡単に見ることができるようにするために、toStringを実装する。
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
