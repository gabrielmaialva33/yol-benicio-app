import 'package:benicio/features/history/history_page.dart';
import 'package:flutter/material.dart';

import '../../../features/shared/services/mock_service.dart';
import '../models/folder.dart';

class FolderConsultationPage extends StatefulWidget {
  const FolderConsultationPage({super.key});

  @override
  State<FolderConsultationPage> createState() => _FolderConsultationPageState();
}

class _FolderConsultationPageState extends State<FolderConsultationPage> {
  final MockService _mockService = MockService();
  late List<Folder> _folders;

  @override
  void initState() {
    super.initState();
    _folders = _mockService.getFolders(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Pastas'),
      ),
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          final folder = _folders[index];
          return ListTile(
            title: Text(folder.title),
            subtitle: Text(folder.client.name),
            trailing: Icon(
              folder.isFavorite ? Icons.star : Icons.star_border,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
