import 'package:basic_registration/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) async {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to sign out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
