import 'package:flutter/material.dart';
import '../models/entry.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;
  final VoidCallback? onTap;
  const EntryCard({Key? key, required this.entry, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: entry.photoPath != null
            ? const Icon(Icons.photo)
            : const Icon(Icons.location_on),
        title: Text(entry.title),
        subtitle: Text(
          '${entry.createdAt.toLocal()}\n${entry.lat != null ? '${entry.lat}, ${entry.lng}' : ''}',
        ),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }
}
