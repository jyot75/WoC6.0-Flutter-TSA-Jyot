import 'package:flutter/material.dart';
import 'package:stockapp/constants/routes.dart';
import 'package:stockapp/enums/menu_action.dart';
import 'package:stockapp/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          PopupMenuButton<MenuActions>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuActions>(
                    value: MenuActions.logout, child: Text('logout'))
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final shouldLogout = await showLogOutDialog(context) ?? false;
                  if (shouldLogout) {
                    AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
              }
            },
          )
        ],
      ),
      body: const Text('Hello Worlddd'),
    );
  }
}

Future<bool?> showLogOutDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to Logout ?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
          ]);
    },
  );
}
