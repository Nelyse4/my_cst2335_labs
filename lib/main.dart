import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  var _counter = 0.0;
  var myFontSize= 30.0;
  // Function to set new values for both counter and font size
  void _setNewValue(var newValue) {
    setState(() {
      _counter = newValue;   // Set the counter value with the slider's value
      myFontSize = newValue; // Set the font size with the slider's value
    });
  }
  void _incrementCounter(){
    setState(() {
      if (_counter < 99.0){
        _counter++;
        myFontSize++;
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'Number of times the button is pushed:',
              style: TextStyle(fontSize: myFontSize),
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: myFontSize),
            ),

            Slider(
              value: _counter,
              min: 0.0,
              max: 100.0,
              onChanged: _setNewValue, // Call the function to update counter and font size
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,

        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}