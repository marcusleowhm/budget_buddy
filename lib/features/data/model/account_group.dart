import 'package:uuid/uuid.dart';

class AccountGroup {

  AccountGroup({ required this.name });

  String id = const Uuid().v4();
  final String name;

}