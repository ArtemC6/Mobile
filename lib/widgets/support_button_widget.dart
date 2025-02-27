import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:voccent/home/cubit/models/user/user.dart';

class SupportButtonWidget extends StatelessWidget {
  const SupportButtonWidget({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async {
        final languageCode = Localizations.localeOf(context).languageCode;

        await Intercom.instance.loginIdentifiedUser(
          email: user.credId ?? '',
        );
        await Intercom.instance.updateUser(
          name: '${user.firstname ?? ''} ${user.lastname ?? ''}',
          userId: user.username,
          language: languageCode,
        );
        await Intercom.instance.displayMessenger();
      },
      backgroundColor: const Color.fromARGB(255, 102, 102, 255),
      child: const Icon(Icons.support_agent),
    );
  }
}
