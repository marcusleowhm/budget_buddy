import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: OutlinedButton(
          onPressed: () {
            print('Implement sign out');
          },
          style: ButtonStyle(
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.red)),
            ),
            foregroundColor: MaterialStatePropertyAll<Color>(
              Theme.of(context).canvasColor,
            ),
            backgroundColor: const MaterialStatePropertyAll<Color>(
              Colors.red,
            ),
          ),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
