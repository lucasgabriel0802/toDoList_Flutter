import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameEC = TextEditingController();

  HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(100),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                    );
                  },
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png?20200919003010';
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      builder: (_, value, __) {
                        return Text(
                          value,
                        );
                      },
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ?? 'Nome não encontrado';
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
              leading: const Icon(Icons.change_circle),
              title: Text(
                'Alterar Nome',
                style: context.titleStyle,
              ),
              onTap: () {
                nameEC.text = context.read<UserService>().getDisplayName() ?? 'Não informado';
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('Alterar Nome'),
                        content: TextField(
                          controller: nameEC,
                          decoration: const InputDecoration(hintText: 'Digite seu nome'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final name = nameEC.text;
                              if (name.isEmpty) {
                                return Messages.of(context).showError('Nome não pode ser vazio');
                              } else {
                                Loader.show(context);
                                context.read<UserService>().updateDisplayName(name);
                                Loader.hide();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      );
                    });
              }),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              'Sair',
              style: context.titleStyle,
            ),
            onTap: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
    );
  }
}
