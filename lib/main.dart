import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HomePage Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Shopping List App'),
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
  @override
  Widget build(BuildContext context) {
    return const ListPage();
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();

  // List to store shopping items
  List<Map<String, String>> shoppingList = [];

  // Add item to the shopping list
  void addItem() {
    if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      setState(() {
        shoppingList.add({
          'item': _itemController.text,
          'quantity': _quantityController.text,
        });
      });
      _itemController.clear();
      _quantityController.clear();
    }
  }

  // Remove item from the shopping list
  void removeItem(int index) {
    setState(() {
      shoppingList.removeAt(index);
    });
  }

  // Show a confirmation dialog for item deletion
  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Do you want to delete "${shoppingList[index]['item']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                removeItem(index); // Remove the item
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Yes'),
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
        title: Text('Flutter HomePage Demo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row with TextFields and Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(hintText: 'Enter Item'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Enter Quantity'),
                  ),
                ),
                TextButton(
                  onPressed: addItem,
                  child: Text('Add', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display shopping list or empty message
            shoppingList.isEmpty
                ? Center(child: Text('There are no items in the list'))
                : Expanded(
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      confirmDelete(index); // Show confirmation dialog on long press
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${index + 1}. ${shoppingList[index]['item']}'),  // Row number and item name
                          Text('Qty: ${shoppingList[index]['quantity']}'),  // Quantity
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
