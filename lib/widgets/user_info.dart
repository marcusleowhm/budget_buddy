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
      leading: CircleAvatar(
        child: Image.network(
          'https://www.w3schools.com/howto/img_avatar.png',
        ),
      ),
      title: Text(name),
      subtitle: Text(joinDate),
    );
  }
}
