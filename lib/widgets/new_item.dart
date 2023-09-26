import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // gives access to form widgets it's connected to
  final _formKey = GlobalKey<FormState>();

  // trigger validation
  void _saveItem() {
    _formKey.currentState!.validate(); // executes form validator functions
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
                  decoration: const InputDecoration(
                    label: Text(
                      'Quantity',
                    ),
                  ),
                  initialValue: '1', // set as a string not a number
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      // return this error message is form validation fails
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              // MUST BE WRAPPED WITH EXPANDED WIDGET TO AVOID A HORIZONTAL CONSTRAINT RENDERING ERROR
              Expanded(
                child: DropdownButtonFormField(
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
                  onChanged: (value) {},
                ),
              )
            ]),
            const SizedBox(
              height: 14,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextButton(
                onPressed: () {},
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
                onPressed: _saveItem,
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
