import '../../shared/models/client.dart';
import '../../shared/models/user.dart';

enum FolderStatus {
  active,
  completed,
  pending,
  cancelled,
  archived,
}

enum FolderArea {
  civilLitigation,
  labor,
  tax,
  criminal,
  administrative,
  consumer,
  family,
  corporate,
  environmental,
  intellectualProperty,
  realEstate,
  international,
}

class Folder {
  final int id;
  final String code;
  final String title;
  final FolderStatus status;
  final FolderArea area;
  final Client client;
  final User responsibleLawyer;
  final DateTime createdAt;
  final int documentsCount;
  final bool isFavorite;

  Folder({
    required this.id,
    required this.code,
    required this.title,
    required this.status,
    required this.area,
    required this.client,
    required this.responsibleLawyer,
    required this.createdAt,
    required this.documentsCount,
    required this.isFavorite,
  });
}
