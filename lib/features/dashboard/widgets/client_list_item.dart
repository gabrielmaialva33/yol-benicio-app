import 'package:flutter/material.dart';

class ClientListItem extends StatelessWidget {
  final String title;
  final String dueDate;
  final Color color;

  const ClientListItem({
    super.key,
    required this.title,
    required this.dueDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          color: color,
        ),
        title: Text(title),
        subtitle: Text(dueDate),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Ação ao tocar no item
        },
      ),
    );
  }
}
