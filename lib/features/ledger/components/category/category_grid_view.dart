import 'package:flutter/material.dart';

@Deprecated('Category would not be using grid view, use CategoryListView instead')
class CategoryGridView extends StatelessWidget {
  const CategoryGridView({
    super.key,
    required this.categories,
    required this.onItemPressed,
  });

  final List<String> categories;
  final void Function(String?) onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 64,
          crossAxisCount: 3,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border.all(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                categories[index],
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () => onItemPressed(categories[index]),
          );
        },
      ),
    );
  }
}
