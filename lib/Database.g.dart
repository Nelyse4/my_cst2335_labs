// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ToDoDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ToDoDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ToDoDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ToDoDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorToDoDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ToDoDatabaseBuilderContract databaseBuilder(String name) =>
      _$ToDoDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ToDoDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ToDoDatabaseBuilder(null);
}

class _$ToDoDatabaseBuilder implements $ToDoDatabaseBuilderContract {
  _$ToDoDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ToDoDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ToDoDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ToDoDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ToDoDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ToDoDatabase extends ToDoDatabase {
  _$ToDoDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Todo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `quantity` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'Todo',
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _todoUpdateAdapter = UpdateAdapter(
            database,
            'Todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _todoDeletionAdapter = DeletionAdapter(
            database,
            'Todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  final UpdateAdapter<Todo> _todoUpdateAdapter;

  final DeletionAdapter<Todo> _todoDeletionAdapter;

  @override
  Future<List<Todo>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM Todo',
        mapper: (Map<String, Object?> row) => Todo(
            row['id'] as int?, row['name'] as String, row['quantity'] as int?));
  }

  @override
  Future<Todo?> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM Todo WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Todo(
            row['id'] as int?, row['name'] as String, row['quantity'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> insertItem(Todo person) async {
    await _todoInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Todo person) async {
    await _todoUpdateAdapter.update(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Todo person) async {
    await _todoDeletionAdapter.delete(person);
  }
}
