import 'package:floor/floor.dart';

@entity
class Todo { // Changed to uppercase 'Todo'
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int? quantity;

  Todo(this.id, this.name, this.quantity); // Changed to uppercase 'Todo'

  @override
  String toString() {
    return "$id: $name $quantity";
  }
}