import 'package:floor/floor.dart';

@entity
class Todo { // Changed to uppercase 'Todo'
  static int ID = 1;
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int? quantity;

  Todo(this.id, this.name, this.quantity); // Changed to uppercase 'Todo'
  String get todoItem => name;
  @override
  String toString() {
    return "$id: $name $quantity";
  }
}