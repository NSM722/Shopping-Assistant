import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
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
          child: Column(children: [
            Expanded(
              child: TextFormField(
                validator: (value) {
                  // return this error message is form validation fails
                  return 'Demo Text....';
                },
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text(
                    'Name',
                  ),
                ),
              ),
            ),
            Row(children: [
              // MUST BE WRAPPED WITH EXPANDED WIDGET TO AVOID A HORIZONTAL CONSTRAINT RENDERING ERROR
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Quantity',
                    ),
                  ),
                  initialValue: '1', // set as a string not a number
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
            ])
          ]),
        ),
      ),
    );
  }
}