import 'package:flutter/material.dart';
import 'TodoDao.dart';
import 'Todo.dart';
import 'Database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter HomePage Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todoList = <Todo>[];
  late TodoDao todoDao;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  Todo? selectedItem;

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();

    $FloorToDoDatabase
        .databaseBuilder('todo_Database.db')
        .build()
        .then((database) async {
      todoDao = database.todoDao;
      loadItems(); // Load items on startup
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void loadItems() {
    todoDao.findAllItems().then((items) {
      setState(() {
        todoList = items;
      });
    });
  }

  void deleteItem() {
    if (selectedItem != null) {
      todoDao.deleteItem(selectedItem!);
      setState(() {
        todoList.remove(selectedItem);
        selectedItem = null; // Clear the selected item after deletion
      });
    }
  }

  void selectItem(Todo item) {
    setState(() {
      selectedItem = item;
    });
  }

  void addItem() {
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty) {
      int? quantity = int.tryParse(_controller2.text);
      if (quantity != null) {
        var newItem = Todo(Todo.ID++, _controller1.text, quantity);
        todoDao.insertItem(newItem);  // Insert the item and update UI immediately
        setState(() {
          todoList.add(newItem);
          _controller1.clear();
          _controller2.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quantity must be a number')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Input fields are required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: reactiveLayout(),  //  reactiveLayout here
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Responsive layout for Portrait and Landscape mode
  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    if ((width> height)&& (width > 720)) {
      // Landscape mode: Show list and details side by side
      return Row(
        children: [
          Expanded(flex: 1, child: toDoList()),
          Expanded(flex: 2, child: detailsPage())
        ],
      );
    } else {
      // Portrait mode: Show either list or details based on selection
      if (selectedItem == null) {
        return toDoList();
      } else {
        return detailsPage();
      }
    }
  }

  // ToDo List Widget
  Widget toDoList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 20),
              Flexible(
                child: TextField(
                  controller: _controller1,
                  decoration: const InputDecoration(hintText: 'Enter a ToDo Item'),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextField(
                  controller: _controller2,
                  decoration: const InputDecoration(hintText: 'Enter quantity'),
                  keyboardType: TextInputType.number,
                ),
              ),
              ElevatedButton(
                onPressed: addItem,
                child: const Text("Add "),
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, rowNum) {
                return GestureDetector(
                  onTap: () {
                    selectItem(todoList[rowNum]);
                  },
                  child:
                  Text(" ${rowNum + 1}. ${todoList[rowNum].todoItem} ${todoList[rowNum].quantity}",
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Details Page Widget
  Widget detailsPage() {
    return Column(
      children: [
        if (selectedItem == null)
          const Text(
            "Please select an item from the list",
            style: TextStyle(fontSize: 24.0),
          )
        else
          Column(
            children: [
              Text(
                "ID: ${selectedItem!.id}",
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                "Selected Item: ${selectedItem!.todoItem}",
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                "Quantity: ${selectedItem!.quantity}",
                style: const TextStyle(fontSize: 18.0),
              ),
              ElevatedButton(
                onPressed: deleteItem,
                child: const Text("Delete Item"),
              ),
            ],
          ),
      ],
    );
  }
}
