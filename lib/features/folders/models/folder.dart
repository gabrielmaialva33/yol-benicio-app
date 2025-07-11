import '../../shared/models/client.dart';
import '../../shared/models/user.dart';

enum FolderStatus {
  active,
  completed,
  pending,
  cancelled,
  archived,
  suspended,
}

enum FolderPriority {
  low,
  medium,
  high,
  urgent,
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

extension FolderAreaExtension on FolderArea {
  String get displayName {
    switch (this) {
      case FolderArea.civilLitigation:
        return 'Cível Contencioso';
      case FolderArea.labor:
        return 'Trabalhista';
      case FolderArea.tax:
        return 'Tributário';
      case FolderArea.criminal:
        return 'Criminal';
      case FolderArea.administrative:
        return 'Administrativo';
      case FolderArea.consumer:
        return 'Consumidor';
      case FolderArea.family:
        return 'Família';
      case FolderArea.corporate:
        return 'Empresarial';
      case FolderArea.environmental:
        return 'Ambiental';
      case FolderArea.intellectualProperty:
        return 'Propriedade Intelectual';
      case FolderArea.realEstate:
        return 'Imobiliário';
      case FolderArea.international:
        return 'Internacional';
    }
  }
}

extension FolderStatusExtension on FolderStatus {
  String get displayName {
    switch (this) {
      case FolderStatus.active:
        return 'Ativo';
      case FolderStatus.completed:
        return 'Concluído';
      case FolderStatus.pending:
        return 'Pendente';
      case FolderStatus.cancelled:
        return 'Cancelado';
      case FolderStatus.archived:
        return 'Arquivado';
      case FolderStatus.suspended:
        return 'Suspenso';
    }
  }
}

class Folder {
  final int id;
  final String code;
  final String title;
  final String? description;
  final FolderStatus status;
  final FolderPriority priority;
  final FolderArea area;
  final Client client;
  final User responsibleLawyer;
  final List<User>? assistantLawyers;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final int documentsCount;
  final bool isFavorite;
  final double? contractValue;
  final double? alreadyBilled;
  final String? courtNumber;
  final String? processNumber;
  final List<String>? tags;
  final String? notes;

  Folder({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    required this.status,
    this.priority = FolderPriority.medium,
    required this.area,
    required this.client,
    required this.responsibleLawyer,
    this.assistantLawyers,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    required this.documentsCount,
    this.isFavorite = false,
    this.contractValue,
    this.alreadyBilled,
    this.courtNumber,
    this.processNumber,
    this.tags,
    this.notes,
  });

  // Helper methods
  bool get isActive => status == FolderStatus.active;

  bool get isOverdue => dueDate != null && DateTime.now().isAfter(dueDate!);

  bool get hasValue => contractValue != null && contractValue! > 0;

  double get pendingBilling {
    if (contractValue == null) return 0.0;
    return contractValue! - (alreadyBilled ?? 0.0);
  }

  int get daysSinceCreation {
    return DateTime
        .now()
        .difference(createdAt)
        .inDays;
  }

  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }
}
