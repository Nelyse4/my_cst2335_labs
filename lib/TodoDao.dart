import 'package:floor/floor.dart';
import 'Todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM Todo')
  Future<List<Todo>> findAllItems();

  @Query('SELECT * FROM Todo WHERE id = :id')
  Future<Todo?> findItemById(int id);

  @insert
  Future<void> insertItem(Todo item);

  @update
  Future<void> updateItem(Todo item);

  @delete
  Future<void> deleteItem(Todo item);


}