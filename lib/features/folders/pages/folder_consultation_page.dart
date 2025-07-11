import 'package:flutter/material.dart';

import '../../../features/shared/models/client.dart';
import '../../../features/shared/models/user.dart';
import '../models/folder.dart';

class FolderConsultationPage extends StatefulWidget {
  const FolderConsultationPage({super.key});

  @override
  State<FolderConsultationPage> createState() => _FolderConsultationPageState();
}

class _FolderConsultationPageState extends State<FolderConsultationPage> {
  late List<Folder> _folders;

  @override
  void initState() {
    super.initState();
    _folders = _getMockFolders();
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
          );
        },
      ),
    );
  }

  List<Folder> _getMockFolders() {
    return [
      Folder(
        id: 1,
        code: 'P001',
        title: 'Processo de Indenização',
        status: FolderStatus.active,
        area: FolderArea.civilLitigation,
        client: Client(id: 1, name: 'João Silva', document: '123.456.789-00'),
        responsibleLawyer:
            User(id: 1, fullName: 'Dr. Carlos', email: 'carlos@benicio.com'),
        createdAt: DateTime.now(),
        documentsCount: 10,
        isFavorite: true,
      ),
      Folder(
        id: 2,
        code: 'P002',
        title: 'Reclamação Trabalhista',
        status: FolderStatus.pending,
        area: FolderArea.labor,
        client: Client(id: 2, name: 'Maria Santos', document: '987.654.321-00'),
        responsibleLawyer:
            User(id: 2, fullName: 'Dra. Ana', email: 'ana@benicio.com'),
        createdAt: DateTime.now(),
        documentsCount: 5,
        isFavorite: false,
      ),
    ];
  }
}
