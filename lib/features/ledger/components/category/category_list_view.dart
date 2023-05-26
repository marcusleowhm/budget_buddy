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
  final Map<String, List<String>> categoryGroups;
  final void Function(int) selectGroupIndex;
  final void Function(String) onSelectCategory;

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
                          child: ListTile(
                            onTap: () => selectGroupIndex(index),
                            title: Text(
                              categoryGroups.keys.elementAt(index),
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
                                '${categoryGroups.keys.elementAt(selectedGroupIndex)} (${categoryGroups.values.elementAt(selectedGroupIndex).elementAt(index)})',
                              );
                            },
                            title: Text(
                              categoryGroups.values
                                  .elementAt(selectedGroupIndex)
                                  .elementAt(index),
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
