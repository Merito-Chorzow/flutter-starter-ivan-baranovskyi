import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/entry_store.dart';
import '../widgets/entry_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    final store = Provider.of<EntryStore>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => store.load());
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EntryStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoDiary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Builder(
        builder: (ctx) {
          if (store.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (store.error != null)
            return Center(child: Text('Błąd: ${store.error}'));
          if (store.items.isEmpty)
            return Center(child: Text('Brak wpisów. Dodaj pierwszy.'));
          return ListView.builder(
            itemCount: store.items.length,
            itemBuilder: (_, i) => EntryCard(
              entry: store.items[i],
              onTap: () => Navigator.pushNamed(
                context,
                '/details',
                arguments: store.items[i].id,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
