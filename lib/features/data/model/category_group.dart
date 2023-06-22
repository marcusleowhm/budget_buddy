import 'package:budget_buddy/features/constants/enum.dart';
import 'package:uuid/uuid.dart';

class CategoryGroup {
  CategoryGroup({required this.name, required this.type});

  String id = const Uuid().v4();
  final String name;
  final CategoryType type;
}
