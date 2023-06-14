import 'package:budget_buddy/features/constants/enum.dart';
import 'package:flutter/material.dart';

import '../../../../../mock/account.dart';
import '../account/account_grid_view.dart';
import '../account/account_list_view.dart';
import 'category_list_view.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({
    super.key,
    required this.type,
    required this.onPressed,
  });

  final TransactionType type;
  final void Function(String? selectedCategory, String? selectedSubCategory)
      onPressed;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  bool isGridView = true;
  int selectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> accounts = [];
    accountGroups.forEach((key, value) {
      if (value.isEmpty) {
        accounts.add(key);
      } else {
        accounts += value;
      }
    });

    @Deprecated('outflowCategories unused. Reserved for category grid view')
    List<String> outflowCategories = [];
    outflowCategoryGroups.forEach((key, value) => outflowCategories += value);

    @Deprecated('inflowCategories unused. Reserved for category grid view')
    List<String> inflowCategories = [];
    inflowCategoryGroups.forEach((key, value) => inflowCategories += value);

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
                    onPressed: () => widget.onPressed(null, null),
                    icon: const Icon(Icons.cancel_rounded),
                    color: Theme.of(context).canvasColor,
                  ),
                  if (widget.type == TransactionType.transfer)
                    IconButton(
                      onPressed: () => setState(() => isGridView = !isGridView),
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
            widget.type == TransactionType.transfer
                ? isGridView
                    ? AccountGridView(
                        accountGroups: accountGroups,
                        onItemPressed: widget.onPressed,
                      )
                    : AccountListView(
                        selectedGroupIndex: selectedGroupIndex,
                        accountGroups: accountGroups,
                        selectGroupIndex: (index) {
                          setState(() => selectedGroupIndex = index);
                        },
                        onSelectAccount: widget.onPressed)
                : widget.type == TransactionType.expense
                    ? CategoryListView(
                        selectedGroupIndex: selectedGroupIndex,
                        categoryGroups: outflowCategoryGroups,
                        selectGroupIndex: (index) {
                          setState(() => selectedGroupIndex = index);
                        },
                        onSelectCategory: widget.onPressed,
                      )
                    : CategoryListView(
                        selectedGroupIndex: selectedGroupIndex,
                        categoryGroups: inflowCategoryGroups,
                        selectGroupIndex: (index) {
                          setState(() => selectedGroupIndex = index);
                        },
                        onSelectCategory: widget.onPressed,
                      ),
          ],
        ),
      ),
    );
  }
}
