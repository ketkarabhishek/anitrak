import 'package:anitrak/src/pages/accounts_page.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.sync_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text("Tracking"),
            subtitle: const Text("Manage your anime tracking accounts"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
