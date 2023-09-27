import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    // receive data from the new_item screen asynchronously
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => const NewItem(),
    ));

    // new item could be null incase the user presses the back button
    // hence handling such use-case
    if (newItem == null) {
      return; // return nothing
    }

    // else add it to the list
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenContent = const Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          'You have no items on your list, add some!',
          style: TextStyle(
            wordSpacing: 1.6,
          ),
        ),
      ),
    );

    // overwrite the content if the list isn't empty
    if (_groceryItems.isNotEmpty) {
      screenContent = ListView.builder(
          itemCount: _groceryItems.length, // necessary for optimization
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) => _removeItem(_groceryItems[index]),
              background: Container(
                color: Colors.red[800],
              ),
              child: ListTile(
                title: Text(
                  _groceryItems[index].name,
                ),
                leading: Container(
                  width: 27,
                  height: 27,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(
                  _groceryItems[index]
                      .quantity
                      .toString(), // output the quantity
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries'), actions: [
        IconButton(
          onPressed: _addItem,
          icon: const Icon(Icons.add),
        )
      ]),
      body: screenContent,
    );
  }
}
