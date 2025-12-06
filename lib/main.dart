import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/list_screen.dart';
import 'screens/add_entry_screen.dart';
import 'screens/details_screen.dart';
import 'screens/settings_screen.dart';
import 'services/entry_store.dart';

void main() => runApp(const GeoDiaryApp());

class GeoDiaryApp extends StatelessWidget {
  const GeoDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EntryStore(),
      child: Consumer<EntryStore>(
        builder: (context, store, _) => MaterialApp(
          title: 'GeoDiary',
          theme: store.isDark ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/': (_) => const ListScreen(),
            '/add': (_) => const AddEntryScreen(),
            '/settings': (_) => const SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/details') {
              final id = settings.arguments as String;
              return MaterialPageRoute(builder: (_) => DetailsScreen(id: id));
            }
            return null;
          },
        ),
      ),
    );
  }
}
