import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/constants/enum.dart';
import 'package:budget_buddy/features/data/model/category.dart';
import 'package:budget_buddy/features/data/model/category_group.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit()
      : super(
          const CategoryState(
            categories: [],
            categoryGroups: [],
          ),
        );

  void fetchCategories() {
    fetchInflowCategories();
    fetchOutflowCategories();
  }

  void fetchInflowCategories() {
    List<CategoryGroup> inflowCategoryGroups = [];
    CategoryGroup incomeCategoryGroup = CategoryGroup(
      name: 'Income',
      type: CategoryType.inflow,
    );
    CategoryGroup investmentCategoryGroup = CategoryGroup(
      name: 'Investment',
      type: CategoryType.inflow,
    );
    CategoryGroup othersCategoryGroup = CategoryGroup(
      name: 'Others',
      type: CategoryType.inflow,
    );
    CategoryGroup bonusCategoryGroup = CategoryGroup(
      name: 'Bonus',
      type: CategoryType.inflow,
    );

    inflowCategoryGroups.add(incomeCategoryGroup);
    inflowCategoryGroups.add(investmentCategoryGroup);
    inflowCategoryGroups.add(othersCategoryGroup);
    inflowCategoryGroups.add(bonusCategoryGroup);

    List<Category> inflowCategories = [];
    inflowCategories.add(Category(
      group: incomeCategoryGroup,
      name: 'Salary',
    ));
    inflowCategories.add(Category(
      group: incomeCategoryGroup,
      name: 'Interest',
    ));
    inflowCategories.add(Category(
      group: investmentCategoryGroup,
      name: 'Thinkorswim',
    ));
    inflowCategories.add(Category(
      group: investmentCategoryGroup,
      name: 'CityIndex',
    ));
    inflowCategories.add(Category(
      group: investmentCategoryGroup,
      name: 'Dividend',
    ));

    inflowCategories.add(Category(
      group: bonusCategoryGroup,
      name: 'Bonus',
    ));
    inflowCategories.add(Category(
      group: othersCategoryGroup,
      name: 'Others',
    ));
    emit(CategoryState(
      categoryGroups: [...state.categoryGroups, ...inflowCategoryGroups],
      categories: [...state.categories, ...inflowCategories],
    ));
  }

  void fetchOutflowCategories() {
    List<CategoryGroup> outflowCategoryGroups = [];
    CategoryGroup fnbCategoryGroup = CategoryGroup(
      name: 'Food & Beverage',
      type: CategoryType.outflow,
    );
    CategoryGroup leisureCategoryGroup = CategoryGroup(
      name: 'Leisure',
      type: CategoryType.outflow,
    );
    CategoryGroup transportCategoryGroup = CategoryGroup(
      name: 'Transport',
      type: CategoryType.outflow,
    );
    CategoryGroup housingCategoryGroup = CategoryGroup(
      name: 'Housing',
      type: CategoryType.outflow,
    );
    CategoryGroup shoppingCategoryGroup = CategoryGroup(
      name: 'Shopping',
      type: CategoryType.outflow,
    );
    CategoryGroup othersCategoryGroup = CategoryGroup(
      name: 'Others',
      type: CategoryType.outflow,
    );

    outflowCategoryGroups.add(shoppingCategoryGroup);
    outflowCategoryGroups.add(othersCategoryGroup);
    outflowCategoryGroups.add(fnbCategoryGroup);
    outflowCategoryGroups.add(leisureCategoryGroup);
    outflowCategoryGroups.add(transportCategoryGroup);
    outflowCategoryGroups.add(housingCategoryGroup);

    List<Category> outflowCategories = [];
    outflowCategories.add(Category(
      group: fnbCategoryGroup,
      name: 'Eating Out',
    ));
    outflowCategories.add(Category(
      group: fnbCategoryGroup,
      name: 'Groceries',
    ));
    outflowCategories.add(Category(
      group: fnbCategoryGroup,
      name: 'Snacks',
    ));
    outflowCategories.add(Category(
      group: fnbCategoryGroup,
      name: 'Drinks',
    ));
    outflowCategories.add(Category(
      group: fnbCategoryGroup,
      name: 'Convenience Store',
    ));
    outflowCategories.add(Category(
      group: leisureCategoryGroup,
      name: 'Videogames',
    ));
    outflowCategories.add(Category(
      group: leisureCategoryGroup,
      name: 'Holiday',
    ));
    outflowCategories.add(Category(
      group: leisureCategoryGroup,
      name: 'Arcade',
    ));
    outflowCategories.add(Category(
      group: transportCategoryGroup,
      name: 'Bus',
    ));
    outflowCategories.add(Category(
      group: transportCategoryGroup,
      name: 'MRT',
    ));
    outflowCategories.add(Category(
      group: transportCategoryGroup,
      name: 'Car',
    ));
    outflowCategories.add(Category(
      group: transportCategoryGroup,
      name: 'Taxi',
    ));
    outflowCategories.add(Category(
      group: housingCategoryGroup,
      name: 'Renovation',
    ));
    outflowCategories.add(Category(
      group: housingCategoryGroup,
      name: 'Maintenance',
    ));
    outflowCategories.add(Category(
      group: housingCategoryGroup,
      name: 'Furniture',
    ));
    outflowCategories.add(Category(
      group: shoppingCategoryGroup,
      name: 'e-Commerce',
    ));
    outflowCategories.add(Category(
      group: shoppingCategoryGroup,
      name: 'Clothes',
    ));
    outflowCategories.add(Category(
      group: othersCategoryGroup,
      name: 'Others',
    ));

    emit(CategoryState(
      categoryGroups: [...state.categoryGroups, ...outflowCategoryGroups],
      categories: [...state.categories, ...outflowCategories],
    ));
  }
}
