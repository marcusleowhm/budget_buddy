import 'package:budget_buddy/features/ledger/components/account/account_grid_view.dart';
import 'package:budget_buddy/features/ledger/components/account/account_list_view.dart';
import 'package:budget_buddy/features/ledger/components/category/category_list_view.dart';
import 'package:flutter/material.dart';

import '../../../../mock/account.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({
    super.key,
    required this.isTransfer,
    required this.onPressed,
  });

  final bool isTransfer;
  final void Function(String? selectedCategory) onPressed;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  bool isGridView = true;
  int selectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> accounts = [];
    accountGroups.forEach((key, value) => accounts += value);

    List<String> categories = [];
    categoryGroups.forEach((key, value) => categories += value);

    return FractionallySizedBox(
        heightFactor: 0.4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => widget.onPressed(null),
                      icon: const Icon(Icons.cancel_rounded),
                      color: Theme.of(context).canvasColor,
                    ),
                    if (widget.isTransfer)
                      IconButton(
                        onPressed: () =>
                            setState(() => isGridView = !isGridView),
                        icon: isGridView
                            ? const Icon(Icons.list)
                            : const Icon(Icons.window_rounded),
                        color: Theme.of(context).canvasColor,
                      ),
                    IconButton(
                      onPressed: () {}, //TODO edit button
                      icon: const Icon(Icons.mode_edit_outline_outlined),
                      color: Theme.of(context).canvasColor,
                    ),
                  ],
                ),
              ),
              widget.isTransfer
                  ? isGridView
                      ? AccountGridView(
                          accounts: accounts,
                          onItemPressed: widget.onPressed,
                        )
                      : AccountListView(
                          selectedGroupIndex: selectedGroupIndex,
                          accountGroups: accountGroups,
                          selectGroupIndex: (index) {
                            setState(() => selectedGroupIndex = index);
                          },
                          onSelectAccount: widget.onPressed)
                  : CategoryListView(
                      selectedGroupIndex: selectedGroupIndex,
                      categoryGroups: categoryGroups,
                      selectGroupIndex: (index) {
                        setState(() => selectedGroupIndex = index);
                      },
                      onSelectCategory: widget.onPressed)
              // CategoryGridView(
              //     categories: categories,
              //     onItemPressed: widget.onPressed,
              //   ),
            ],
          ),
        ));
  }
}
