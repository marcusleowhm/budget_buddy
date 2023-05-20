import 'package:flutter/material.dart';

import '../../../mock/account.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({
    super.key,
    required this.context,
    required this.onPressed,
  });

  final BuildContext context;
  final void Function(String? selectedAccount) onPressed;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              color: Theme.of(context).canvasColor,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_edit_outline_outlined),
                ),
                IconButton(
                  onPressed: () => widget.onPressed(null),
                  icon: const Icon(Icons.cancel_rounded),
                ),
              ]),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          border: Border.all()),
                      child: Text(
                        categories[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () => widget.onPressed(categories[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
