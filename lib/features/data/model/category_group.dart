import 'package:uuid/uuid.dart';

class CategoryGroup {
  CategoryGroup({required this.name});

  String id = const Uuid().v4();
  final String name;
}


class InflowCategoryGroup extends CategoryGroup {
  InflowCategoryGroup(name) : super(name: name);
}

class OutflowCategoryGroup extends CategoryGroup {
  OutflowCategoryGroup(name) : super(name: name);
}
