import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/entry_store.dart';

class DetailsScreen extends StatelessWidget {
  final String id;
  const DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EntryStore>(context);
    final e = store.getById(id);
    return Scaffold(
      appBar: AppBar(title: Text(e?.title ?? 'Szczegóły')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (e?.photoPath != null) ...[
              SizedBox(
                height: 200,
                child: Center(child: Text('Zdjęcie: \${e!.photoPath}')),
              ),
            ],
            Text(e?.description ?? ''),
            const SizedBox(height: 12),
            Text('Dodano: \${e?.createdAt.toLocal()}'),
            const Spacer(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    /* share or open map */
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Udostępnij'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    /* open in maps */
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Pokaż na mapie'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
