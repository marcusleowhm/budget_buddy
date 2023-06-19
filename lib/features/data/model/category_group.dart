class CategoryGroup {
  const CategoryGroup({required this.name});

  final String name;
}


class InflowCategoryGroup extends CategoryGroup {
  const InflowCategoryGroup(name) : super(name: name);
}

class OutflowCategoryGroup extends CategoryGroup {
  const OutflowCategoryGroup(name) : super(name: name);
}
