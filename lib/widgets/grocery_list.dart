import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
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
  var _isLoading = true;
  String? _error = '';

  @override
  void initState() {
    super.initState();
    // load the items when the app initializes
    _loadItems();
  }

  // FETCH DATA FROM BE
  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-http-requests-ce06f-default-rtdb.firebaseio.com',
        'shopping-list.json');

    // PROPER ERROR HANDLING

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Unable to complete your request, please try again.';
      });
    }

    // check if the response is equal to 'null' i.e there's no data in BE
    // then display the necessary screen context
    if (response.body == 'null') {
      return [];
    }

    // output of data received from the BE to understand the way it has been typed
    /// {"-NfL7T2bIn80QIPeNsq_":{"category":"Hygiene","name":"Tampons","quantity":2},"-NfLG1XahanrxthIdg1P":{"category":"Other","name":"Tanqueray","quantity":3}}
    final Map<String, dynamic> listData =
        json.decode(response.body); // convert json to Map

    // format to list
    // the output of listData.entries
    /// [MapEntry("-NfL7T2bIn80QIPeNsq_", {category: Hygiene, name: Tampons, quantity: 2}), MapEntry("-NfLG1XahanrxthIdg1P", {category: Other, name: Tanqueray, quantity: 3})]

    /// convert the map entries to a list of grocery items
    /// this is a temporary list to replace _groceryItems
    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      // get the first matching item
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;

      loadedItems.add(GroceryItem(
        id: item.key, // the automatically generated key in Firebase
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      ));
    }
    return _loadItems();
  }

  void _addItem() async {
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => const NewItem(),
    ));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  // SEND DELETE REQUESTS
  void _removeItem(GroceryItem item) async {
    final itemIndex = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
        'flutter-http-requests-ce06f-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    // undo the deletion process if something went wrong
    final deleteResponse = await http.delete(url);

    if (deleteResponse.statusCode >= 400) {
      // add the item back at the specific index
      setState(() {
        _groceryItems.insert(itemIndex, item);
      });
    }
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

    // check for loading effect
    if (_isLoading) {
      screenContent = const Center(
        child: CircularProgressIndicator(
          strokeWidth: 7.0,
          color: Colors.blueAccent,
        ),
      );
    }

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

    if (_error != null) {
      screenContent = Center(
        child: Text(
          _error!,
          style: const TextStyle(
            color: Colors.redAccent,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries'), actions: [
        IconButton(
          onPressed: _addItem,
          icon: const Icon(Icons.add),
        )
      ]),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {},
      ),
    );
  }
}
