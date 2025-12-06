import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/entry_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EntryStore>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Tryb ciemny'),
            value: store.isDark,
            onChanged: (_) => store.toggleTheme(),
          ),
        ],
      ),
    );
  }
}
