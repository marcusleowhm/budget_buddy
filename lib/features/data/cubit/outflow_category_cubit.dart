import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/data/model/category.dart';
import 'package:budget_buddy/features/data/model/category_group.dart';

part 'outflow_category_state.dart';

class OutflowCategoryCubit extends Cubit<OutflowCategoryState> {
  OutflowCategoryCubit()
      : super(const OutflowCategoryState(
            outflowCategories: [], outflowCategoryGroups: []));

  void fetchoutflowCategoryGroups() {
    List<OutflowCategoryGroup> outflowCategories = [];
    OutflowCategoryGroup fnbCategoryGroup =
        const OutflowCategoryGroup('Food & Beverage');
    OutflowCategoryGroup leisureCategoryGroup =
        const OutflowCategoryGroup('Leisure');
    OutflowCategoryGroup transportCategoryGroup =
        const OutflowCategoryGroup('Transport');
    OutflowCategoryGroup housingCategoryGroup =
        const OutflowCategoryGroup('Housing');
    OutflowCategoryGroup shoppingCategoryGroup =
        const OutflowCategoryGroup('Shopping');
    OutflowCategoryGroup othersCategoryGroup =
        const OutflowCategoryGroup('Others');

    outflowCategories.add(shoppingCategoryGroup);
    outflowCategories.add(othersCategoryGroup);
    outflowCategories.add(fnbCategoryGroup);
    outflowCategories.add(leisureCategoryGroup);
    outflowCategories.add(transportCategoryGroup);
    outflowCategories.add(housingCategoryGroup);

    List<OutflowCategory> outflowCategoryGroups = [];
    outflowCategoryGroups.add(OutflowCategory(fnbCategoryGroup, 'Eating Out'));
    outflowCategoryGroups.add(OutflowCategory(fnbCategoryGroup, 'Groceries'));
    outflowCategoryGroups.add(OutflowCategory(fnbCategoryGroup, 'Snacks'));
    outflowCategoryGroups.add(OutflowCategory(fnbCategoryGroup, 'Drinks'));
    outflowCategoryGroups.add(OutflowCategory(fnbCategoryGroup, 'Convenience Store'));
    outflowCategoryGroups.add(OutflowCategory(leisureCategoryGroup, 'Videogames'));
    outflowCategoryGroups.add(OutflowCategory(leisureCategoryGroup, 'Holiday'));
    outflowCategoryGroups.add(OutflowCategory(leisureCategoryGroup, 'Arcade'));
    outflowCategoryGroups.add(OutflowCategory(transportCategoryGroup, 'Bus'));
    outflowCategoryGroups.add(OutflowCategory(transportCategoryGroup, 'MRT'));
    outflowCategoryGroups.add(OutflowCategory(transportCategoryGroup, 'Car'));
    outflowCategoryGroups.add(OutflowCategory(transportCategoryGroup, 'Taxi'));
    outflowCategoryGroups.add(OutflowCategory(housingCategoryGroup, 'Renovation'));
    outflowCategoryGroups.add(OutflowCategory(housingCategoryGroup, 'Maintenance'));
    outflowCategoryGroups.add(OutflowCategory(housingCategoryGroup, 'Furniture'));
    outflowCategoryGroups.add(OutflowCategory(shoppingCategoryGroup, 'e-Commerce'));
    outflowCategoryGroups.add(OutflowCategory(shoppingCategoryGroup, 'Clothes'));
    outflowCategoryGroups.add(OutflowCategory(othersCategoryGroup, 'Others'));

    emit(OutflowCategoryState(
        outflowCategoryGroups: outflowCategories,
        outflowCategories: outflowCategoryGroups));
  }
}
