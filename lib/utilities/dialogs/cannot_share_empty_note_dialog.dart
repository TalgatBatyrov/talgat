import 'package:basic_registration/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showCannotEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
