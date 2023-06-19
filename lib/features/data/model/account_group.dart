import 'package:uuid/uuid.dart';

class AccountGroup {

  AccountGroup({ required this.name });

  String id = Uuid().v4();
  final String name;

}