import 'package:budget_buddy/features/data/model/account_group.dart';
import 'package:uuid/uuid.dart';

class Account {

  Account({
    required this.group,
    required this.name,
    required this.balance,
  });

  final String id = const Uuid().v4();
  final AccountGroup group;
  final String name;
  final double balance;

}
