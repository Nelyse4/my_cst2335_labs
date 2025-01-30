import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu Layout',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
    'BROWSE CATEGORIES',
    style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.none),

    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
    'Not sure about exactly which recipe you\'re looking for? Do a search, or dive into our most popular categories.',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
    ),
    ),


        // BY MEAT Section
        Text(
          'BY MEAT',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImageWithText('BEEF', 'images/beef.jpg'),
            _buildImageWithText('CHICKEN', 'images/chicken.jpg'),
            _buildImageWithText('PORK', 'images/pork.jpg'),
            _buildImageWithText('SEAFOOD', 'images/seafood.jpg'),
          ],
        ),

        // BY COURSE Section
        Text(
          'BY COURSE',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImageWithTextBelow('Main Dishes', 'images/main.jpg'),
            _buildImageWithTextBelow('Salad Recipes', 'images/salad.jpg'),
            _buildImageWithTextBelow('Side Dishes', 'images/side.jpg'),
            _buildImageWithTextBelow('Crockpot', 'images/crockpot.jpg'),
          ],
        ),

        // BY DESSERT Section
        Text(
          'BY DESSERT',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildImageWithTextBelow('Ice Cream', 'images/ice_cream.jpg'),
            _buildImageWithTextBelow('Brownies', 'images/brownies.jpg'),
            _buildImageWithTextBelow('Pies', 'images/pies.jpg'),
            _buildImageWithTextBelow('Cookies', 'images/cookies.jpg'),
          ],
        ),
      ],
    );
  }

  // Function for image with text in the center
  Widget _buildImageWithText(String text, String imagePath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 50,
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
          ),
        ),
      ],
    );
  }

  // New Function for image with text below
  Widget _buildImageWithTextBelow(String text, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 50,
        ),
        SizedBox(height: 8), // Space between image and text
        Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
          ),
        ),
      ],
    );
  }
}

