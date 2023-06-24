import 'package:budget_buddy/features/auth/cubit/authentication_cubit.dart';
import 'package:budget_buddy/features/ledger/widgets/widget_shaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<ShakeErrorState> usernameShakerKey =
      GlobalKey<ShakeErrorState>();
  final GlobalKey<FormFieldState> usernameKey = GlobalKey<FormFieldState>();

  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ShakeErrorState> passwordShakerKey =
      GlobalKey<ShakeErrorState>();
  final GlobalKey<FormFieldState> passwordKey = GlobalKey<FormFieldState>();

  String username = '';
  String password = '';
  bool hidePassword = true;

  @override
  void initState() {
    usernameController.addListener(() {
      setState(() => username = usernameController.text);
    });
    passwordController.addListener(() {
      setState(() => password = passwordController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ShakeError(
        key: usernameShakerKey,
        duration: const Duration(milliseconds: 600),
        shakeCount: 4,
        shakeOffset: 10,
        child: TextFormField(
          key: usernameKey,
          controller: usernameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'User cannot be blank';
            }
            return null;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Username',
            suffixIcon: usernameController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      usernameController.clear();
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  )
                : null,
          ),
          autocorrect: false,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ShakeError(
        key: passwordShakerKey,
        duration: const Duration(milliseconds: 600),
        shakeCount: 4,
        shakeOffset: 10,
        child: TextFormField(
          key: passwordKey,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password cannot be blank';
            }
            return null;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            suffixIcon: passwordController.text.isNotEmpty
                ? hidePassword
                    ? IconButton(
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                        icon: const Icon(Icons.visibility),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                        icon: const Icon(Icons.visibility_off),
                      )
                : null,
          ),
          obscureText: hidePassword,
          autocorrect: false,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        const Text('Or sign in with the following'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Register'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationCubit>(context).authenticate();
                },
                child: const Text('Login'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              print('Implement sign in with Facebook');
            },
            icon: const Icon(Icons.facebook),
            iconSize: 50,
          ),
          IconButton(
            onPressed: () {
              print('Implement sign in with Google');
            },
            icon: const FaIcon(
              FontAwesomeIcons.google,
            ),
            iconSize: 40,
          ),
          IconButton(
            onPressed: () {
              print('Implement sign in with Apple');
            },
            icon: const Icon(Icons.apple),
            iconSize: 50,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Center(
            child: FractionallySizedBox(
              widthFactor: MediaQuery.of(context).size.width >= 768 ? 0.4 : 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildUsernameField(),
                  _buildPasswordField(),
                  _buildButtons(),
                  _buildDivider(),
                  _buildSocialButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
