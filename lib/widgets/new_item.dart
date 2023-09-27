import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // gives access to form widgets it's connected to
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.meat]!; // default value

  // trigger validation
  void _saveItem() {
    // executes form validator functions
    if (_formKey.currentState!.validate()) {
      // Saves every [FormField] that is a descendant of this [Form] and executes the onSaved function in each form widget
      _formKey.currentState!.save();

      // passing on this data from this screen to the grocery list screen
      Navigator.of(context).pop(GroceryItem(
        id: DateTime.now().toString(),
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add a new item',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          // ensure flutter validates this form and triggers all the validator functions
          key: _formKey,
          child: Column(children: [
            TextFormField(
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  // return this error message is form validation fails
                  return 'Must be between 2 and 50 characters long';
                }
                return null;
              },
              // function triggered by calling the .save() at the top
              onSaved: (newValue) {
                _enteredName = newValue!;
              },
              maxLength:
                  50, // & minimum of 2 chars according to the above condition
              decoration: const InputDecoration(
                label: Text(
                  'Name',
                ),
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              // MUST BE WRAPPED WITH EXPANDED WIDGET TO AVOID A HORIZONTAL CONSTRAINT RENDERING ERROR
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text(
                      'Quantity',
                    ),
                  ),
                  initialValue: _enteredQuantity.toString(),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) ==
                            null || // .tryParse() yields null if value can't be converted to a number
                        int.tryParse(value)! <= 0) {
                      // return this error message is form validation fails
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredQuantity = int.parse(
                        newValue!); // .parse() throws an error if value can't be converted to a number
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              // MUST BE WRAPPED WITH EXPANDED WIDGET TO AVOID A HORIZONTAL CONSTRAINT RENDERING ERROR
              Expanded(
                child: DropdownButtonFormField(
                  value: _selectedCategory, // updated when selection changes
                  items: [
                    for (final category in categories.entries)
                      // convert Map to list
                      DropdownMenuItem(
                        value: category.value,
                        child: Row(children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: category.value.color,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            category.value.title,
                          )
                        ]),
                      )
                  ],
                  // triggered when a new selection occurs
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              )
            ]),
            const SizedBox(
              height: 14,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextButton(
                onPressed: () {
                  _formKey.currentState!.reset();
                },
                child: const Text(
                  'Reset',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  right: 4,
                ),
              ),
              ElevatedButton(
                onPressed: _saveItem, // validation triggered on this button
                child: const Text(
                  'Add Item',
                ),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
