import 'package:flutter/material.dart';

class Pizza {
  String toppings;
  String description;
  double price;
  int size;

  static final PIZZA_PRICES = [7.99, 9.99, 12.99, 14.99];
  static final PIZZA_SIZES = ["Small", "Medium", "Large", "X-Large"];

  Pizza({required this.toppings, required this.size})
      : price = PIZZA_PRICES[size],
        description = "${PIZZA_SIZES[size]} $toppings Pizza";
}

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

  List<Pizza> pizzasInOrder = [];

  @override
  void initState() {
    super.initState();
    pizzasInOrder.add(Pizza(toppings: "Pepperoni", size: 1));
    pizzasInOrder.add(Pizza(toppings: "Veggie", size: 2));
  }

  void _addPizza() {
    TextEditingController toppingsController = TextEditingController();
    int tempSizeIndex = 1;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Build Your Pizza'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: toppingsController,
                    decoration: InputDecoration(
                      labelText: "Toppings",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Size: ${Pizza.PIZZA_SIZES[tempSizeIndex]}"),
                  Slider(
                    value: tempSizeIndex.toDouble(),
                    min: 0,
                    max: (Pizza.PIZZA_SIZES.length - 1).toDouble(),
                    divisions: Pizza.PIZZA_SIZES.length - 1,
                    label: Pizza.PIZZA_SIZES[tempSizeIndex],
                    onChanged: (double newValue) {
                      setState(() {
                        tempSizeIndex = newValue.round();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pizzasInOrder.add(Pizza(
                    toppings: toppingsController.text,
                    size: tempSizeIndex,
                  ));
                });
                Navigator.pop(context); // Close dialog
              },
              child: Text("Add Pizza"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
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
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: pizzasInOrder.length,
        itemBuilder: (BuildContext context, int index) {
          final pizza = pizzasInOrder[index];
          return Card(
            child: ListTile(
              title: Text(pizza.description),
              subtitle: Text("\$${pizza.price.toStringAsFixed(2)}"),
              leading: Icon(Icons.local_pizza),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addPizza,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}