import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
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
