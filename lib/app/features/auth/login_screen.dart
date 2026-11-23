import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';

/// Экран входа и регистрации по почте и паролю (Firebase Authentication).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          final loading = state is AuthInProgress;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Вход в приложение',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  8.ph,
                  Text(
                    'Почта и пароль хранятся в Firebase Authentication, '
                    'профиль — в Cloud Firestore.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  24.ph,
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Почта',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (!text.contains('@')) {
                        return 'Введите почту';
                      }
                      return null;
                    },
                  ),
                  12.ph,
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if ((value ?? '').length < 6) {
                        return 'Минимум 6 символов';
                      }
                      return null;
                    },
                  ),
                  20.ph,
                  if (state is AuthFailure)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: loading ? null : () => _submit(register: false),
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Войти'),
                  ),
                  8.ph,
                  TextButton(
                    onPressed: loading ? null : () => _submit(register: true),
                    child: const Text('Зарегистрироваться'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit({required bool register}) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final auth = context.read<AuthCubit>();
    if (register) {
      auth.signUp(_email.text, _password.text);
    } else {
      auth.signIn(_email.text, _password.text);
    }
  }
}
