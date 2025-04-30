import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
      changeNotifier: context.read<LoginController>(),
    ).listener(
      context: context,
      onEverCallback: (notifier, listenerNotifier) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage ?? '');
          }
        }
      },
      onSuccessCallback: (notifier, listenerNotifier) {
        if (notifier.isSuccess) {
          listenerNotifier.disposeListener();
          Messages.of(context).showSuccess('Login realizado com sucesso!');
        }
      },
    );
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const TodoListLogo(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TodoListField(
                              label: 'E-mail',
                              controller: _emailEC,
                              focusNode: _emailFocus,
                              validator: Validatorless.multiple([
                                Validatorless.required('E-mail obrigatório'),
                                Validatorless.email('E-mail inválido'),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            TodoListField(
                              label: 'Senha',
                              obscureText: true,
                              controller: _passwordEC,
                              validator: Validatorless.multiple(
                                  [Validatorless.required('Senha obrigatória')]),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_emailEC.text.isEmpty) {
                                      Messages.of(context)
                                          .showError('Informe o e-mail cadastrado!');
                                      _emailFocus.requestFocus();
                                    } else {
                                      context.read<LoginController>().forgotPassword(_emailEC.text);
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Esqueceu a senha?'),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    final formValid = _formKey.currentState?.validate() ?? false;
                                    if (formValid) {
                                      final controller = context.read<LoginController>();
                                      final String email = _emailEC.text;
                                      final String password = _passwordEC.text;

                                      controller.login(email, password);
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Login',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF0F3F7),
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          SignInButton(
                            Buttons.Google,
                            padding: const EdgeInsets.all(5),
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            onPressed: () {
                              final controller = context.read<LoginController>();
                              controller.googleLogin();
                            },
                            text: 'Continue com o Google',
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não tem uma conta?'),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/register');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Cadastre-se'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
