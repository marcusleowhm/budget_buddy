import 'package:budget_buddy/features/auth/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: OutlinedButton(
        onPressed: () {
          BlocProvider.of<AuthenticationCubit>(context).logout();

          //Reset the navigation to dashboard upon logging out
          context.go('/');
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
    );
  }
}
