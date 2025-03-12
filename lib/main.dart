import 'package:flutter/material.dart';
import 'TodoDao.dart';
import 'Todo.dart';
import 'Database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      var items = await todoDao.findAllItems();
      setState(() {
        todoList = items;
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void addItem() async {
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty) {
      int? quantity = int.tryParse(_controller2.text);
      if (quantity != null) {
        var newItem = Todo(null, _controller1.text, quantity );
        await todoDao.insertItem(newItem);
        var updatedList = await todoDao.findAllItems();
        setState(() {
          todoList = updatedList;
          _controller1.clear();
          _controller2.clear();
        });
      } else {
        var snackBar = SnackBar(content: const Text('Quantity must be a number'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var snackBar = SnackBar(content: const Text('Input field is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void deleteItem(int index) async {
    await todoDao.deleteItem(todoList[index]);
    var updatedList = await todoDao.findAllItems();
    setState(() {
      todoList = updatedList;
    });
  }

  void _showDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                deleteItem(index); // Delete the item
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _controller1,
                decoration: const InputDecoration(
                  hintText: "Type the item here",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller2,
                decoration: const InputDecoration(
                  hintText: "Type the quantity here",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: addItem,
              child: const Text("Add", style: TextStyle(fontSize: 15.0)),
            ),
          ]),
          const SizedBox(height: 10),
          Flexible(child: listPage()),
        ],
      ),
    );
  }

  Widget listPage() {
    if (todoList.isEmpty) {
      return const Center(child: Text("There are no items in the list"));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                _showDialog(index); // Show delete dialog on long press
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${index + 1}:"),
                  const SizedBox(width: 5),
                  Text(todoList[index].name),
                  const SizedBox(width: 10),
                  Text(" quantity: ${todoList[index].quantity}"),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}