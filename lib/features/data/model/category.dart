import 'package:budget_buddy/features/data/model/category_group.dart';
import 'package:uuid/uuid.dart';

class Category {
  Category({required this.group, required this.name});

  String id = const Uuid().v4();
  final CategoryGroup group;
  final String name;
}

class InflowCategory extends Category {
  InflowCategory(CategoryGroup group, String name)
      : super(group: group, name: name);
}

class OutflowCategory extends Category {
  OutflowCategory(CategoryGroup group, String name)
      : super(group: group, name: name);
}
