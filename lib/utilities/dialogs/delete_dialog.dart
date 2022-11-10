import 'package:basic_registration/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) async {
  return showGenericDialog<bool>(
    context: context,
    content: 'Are you sure you want to delete this item?',
    title: 'Delete',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
