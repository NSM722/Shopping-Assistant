import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // gives access to json methods

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    // load the items when the app initializes
    _loadItems();
  }

  // fetch data from BE
  void _loadItems() async {
    final url = Uri.https(
        'flutter-http-requests-ce06f-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);

    // output of data received from the BE to understand the way it has been typed
    /// {"-NfL7T2bIn80QIPeNsq_":{"category":"Hygiene","name":"Tampons","quantity":2},"-NfLG1XahanrxthIdg1P":{"category":"Other","name":"Tanqueray","quantity":3}}
    final Map<String, dynamic> listData =
        json.decode(response.body); // convert json to Map

    // format to list
    // the output of listData.entries
    /// [MapEntry("-NfL7T2bIn80QIPeNsq_", {category: Hygiene, name: Tampons, quantity: 2}), MapEntry("-NfLG1XahanrxthIdg1P", {category: Other, name: Tanqueray, quantity: 3})]

    /// convert the map entries to a list of grocery items
    /// this is a temporary list to replace _groceryItems
    final List<GroceryItem> _loadedItems = [];

    for (final item in listData.entries) {
      // get the first matching item
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;

      _loadedItems.add(GroceryItem(
        id: item.key, // the automatically generated key in Firebase
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      ));
    }

    // re-assign the _groceryItems
    setState(() {
      _groceryItems = _loadedItems;
    });
  }

  void _addItem() async {
    Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => const NewItem(),
    ));

    _loadItems();
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
