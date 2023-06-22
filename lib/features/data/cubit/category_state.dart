part of 'category_cubit.dart';

class CategoryState {
  const CategoryState({
    required this.categories,
    required this.categoryGroups,
  });
  final List<Category> categories;
  final List<CategoryGroup> categoryGroups;
}
