import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem() {
    Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries'), actions: [
        IconButton(
          onPressed: _addItem,
          icon: const Icon(Icons.add),
        )
      ]),
      body: ListView.builder(
          itemCount: groceryItems.length, // necessary for optimization
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                groceryItems[index].name,
              ),
              leading: Container(
                width: 27,
                height: 27,
                color: groceryItems[index].category.color,
              ),
              trailing: Text(
                groceryItems[index].quantity.toString(), // output the quantity
              ),
            );
          }),
    );
  }
}
