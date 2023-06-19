import 'package:bloc/bloc.dart';
import 'package:budget_buddy/features/data/model/category.dart';
import 'package:budget_buddy/features/data/model/category_group.dart';

part 'inflow_category_state.dart';

class InflowCategoryCubit extends Cubit<InflowCategoryState> {
  InflowCategoryCubit()
      : super(
          const InflowCategoryState(
            inflowCategories: [],
            inflowCategoryGroups: [],
          ),
        );

  void fetchInflowCategories() {
    List<InflowCategoryGroup> inflowCategoryGroups = [];
    InflowCategoryGroup incomeCategoryGroup = InflowCategoryGroup('Income');
    InflowCategoryGroup investmentCategoryGroup = InflowCategoryGroup('Investment');
    InflowCategoryGroup othersCategoryGroup = InflowCategoryGroup('Others');
    InflowCategoryGroup bonusCategoryGroup = InflowCategoryGroup('Bonus');

    inflowCategoryGroups.add(incomeCategoryGroup);
    inflowCategoryGroups.add(investmentCategoryGroup);
    inflowCategoryGroups.add(othersCategoryGroup);
    inflowCategoryGroups.add(bonusCategoryGroup);

    List<InflowCategory> inflowCategories = [];
    inflowCategories.add(InflowCategory(incomeCategoryGroup, 'Salary'));
    inflowCategories.add(InflowCategory(incomeCategoryGroup, 'Interest'));
    inflowCategories
        .add(InflowCategory(investmentCategoryGroup, 'Thinkorswim'));
    inflowCategories.add(InflowCategory(investmentCategoryGroup, 'CityIndex'));
    inflowCategories.add(InflowCategory(investmentCategoryGroup, 'Dividend'));

    inflowCategories.add(InflowCategory(bonusCategoryGroup, 'Bonus'));
    inflowCategories.add(InflowCategory(othersCategoryGroup, 'Others'));

    emit(InflowCategoryState(
        inflowCategories: inflowCategories,
        inflowCategoryGroups: inflowCategoryGroups));
  }
}
