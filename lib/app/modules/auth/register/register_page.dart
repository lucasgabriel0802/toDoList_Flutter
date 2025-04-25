import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensios.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void initState() {
    super.initState();

    DefaultListenerNotifier(
      changeNotifier: context.read<RegisterController>(),
    ).listener(
        context: context,
        onSuccessCallback: (changeNotifier, listenerNotifier) {
          if (changeNotifier.isSuccess) {
            listenerNotifier.disposeListener();
            Navigator.of(context).pop();
          }
        });
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: context.primaryColor,
            height: 1,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo List',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 10,
              ),
            ),
            Text(
              'Cadastro',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: context.primaryColor,
                size: 20,
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TodoListField(
                      label: 'E-mail',
                      controller: _emailEC,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('E-mail obrigatório'),
                          Validatorless.email('E-mail inválido'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TodoListField(
                      label: 'Senha',
                      obscureText: true,
                      controller: _passwordEC,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Senha obrigatória'),
                          Validatorless.min(6, 'Senha deve ter no mínimo 6 caracteres'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TodoListField(
                      label: 'Confirmar Senha',
                      obscureText: true,
                      controller: _confirmPasswordEC,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Senha obrigatória'),
                          Validatorless.min(6, 'Senha deve ter no mínimo 6 caracteres'),
                          Validatorless.compare(_passwordEC, 'As senhas não conferem'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final formValid = _formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            final controller = context.read<RegisterController>();
                            final String email = _emailEC.text;
                            final String password = _passwordEC.text;
                            controller.registerUser(
                              email: email,
                              password: password,
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Cadastrar',
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
