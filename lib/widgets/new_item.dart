import 'package:flutter/material.dart';

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
            TextFormField(
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
          ]),
        ),
      ),
    );
  }
}
