import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_bloc/Repository/auth_repository.dart';
import 'package:user_bloc/bloc/auth/form_submission_status.dart';

import '../../../bloc/auth/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({final Key? key}) : super(key: key);

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => LoginBloc(
        authRepo: context.read<AuthRepository>(),
      ),
      child: _loginForm(),
    ));
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _usernameField(),
              const SizedBox(height: 5),
              _passwordField(),
              const SizedBox(height: 10),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'Username',
          ),
          validator: (value) =>
              state.isValidUsername ? null : 'Username is too short',
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginUsernameChanged(value),
              ),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'Password',
          ),
          validator: (value) =>
              state.isValidPassword ? null : 'Password is too short',
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginPasswordChanged(value),
              ),
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.formStatus is FormSubmitting) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginSubmitted());
            }
          },
          child: const Text('Login'),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
