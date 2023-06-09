import 'package:budget_buddy/features/data/model/category.dart';
import 'package:budget_buddy/features/data/model/category_group.dart';
import 'package:flutter/material.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({
    super.key,
    required this.selectedGroupIndex,
    required this.categoryGroups,
    required this.selectGroupIndex,
    required this.onSelectCategory,
  });

  final int selectedGroupIndex;
  final Map<CategoryGroup, List<Category>> categoryGroups;
  final void Function(int) selectGroupIndex;
  final void Function(String, String?) onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Category Group
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoryGroups.keys.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: selectedGroupIndex == index
                                ? Colors.blue[100] //TODO change color
                                : Theme.of(context).canvasColor,
                            border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: categoryGroups.values
                                  .elementAt(index)
                                  .isEmpty
                              //Without chevron, without sub groups. Treat Category as SubCategory
                              ? ListTile(
                                  onTap: () => onSelectCategory(
                                    categoryGroups.keys
                                        .elementAt(index)
                                        .name,
                                    null,
                                  ),
                                  title: Text(
                                    categoryGroups.keys
                                        .elementAt(index)
                                        .name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              //With chevron
                              : ListTile(
                                  onTap: selectedGroupIndex == index
                                      ? () => onSelectCategory(
                                            categoryGroups.keys
                                                .elementAt(index)
                                                .name,
                                            null,
                                          )
                                      : () => selectGroupIndex(index),
                                  title: Text(
                                    categoryGroups.keys
                                        .elementAt(index)
                                        .name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Category Sub Group
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoryGroups.values
                          .elementAt(selectedGroupIndex)
                          .length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            border: Border.all(
                              width: 0.5,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              onSelectCategory(
                                //Value stored in the data structure
                                categoryGroups.keys
                                    .elementAt(selectedGroupIndex)
                                    .name,
                                categoryGroups.values
                                    .elementAt(selectedGroupIndex)
                                    .elementAt(index)
                                    .name,
                              );
                            },
                            title: Text(
                              categoryGroups.values
                                  .elementAt(selectedGroupIndex)
                                  .elementAt(index)
                                  .name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
