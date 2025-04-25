import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({required this.changeNotifier});

  void listener({
    required BuildContext context,
    required SuccessVoidCallback onSuccessCallback,
    ErrorVoidCallback? onErrorCallback,
  }) {
    changeNotifier.addListener(() {
      if (changeNotifier.loading) {
        Loader.show(context);
      } else if (changeNotifier.hasError) {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (onErrorCallback != null) onErrorCallback(changeNotifier, this);
        Messages.of(context).showError(changeNotifier.errorMessage ?? 'Erro desconhecido');
      } else if (changeNotifier.isSuccess) {
        onSuccessCallback(changeNotifier, this);
      }
    });
  }

  void disposeListener() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallback = void Function(
    DefaultChangeNotifier changeNotifier, DefaultListenerNotifier listenerNotifier);
typedef ErrorVoidCallback = void Function(
    DefaultChangeNotifier changeNotifier, DefaultListenerNotifier listenerNotifier);
