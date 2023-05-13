import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String name = "Marcus Leow";
  String joinDate = "Since 1 May 2023";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Text('Just Test'),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(joinDate),
      trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            //TODO implement edit feature for user information
            print('//edit user information');
          }),
    );
  }
}
