enum ClientType {
  individual, // Pessoa física
  corporate, // Pessoa jurídica
}

enum ClientStatus {
  active,
  inactive,
  vip,
}

class Client {
  final int id;
  final String name;
  final String document;
  final ClientType type;
  final ClientStatus status;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? clientSince;
  final int activeFolders;
  final double totalBilled;
  final String? notes;
  final List<String>? folderIds; // IDs das pastas/processos vinculados
  final String? preferredContact; // Email, telefone, whatsapp
  final String? responsibleLawyer; // Advogado principal do cliente
  final Map<String, dynamic>? customFields; // Campos personalizados

  Client({
    required this.id,
    required this.name,
    required this.document,
    required this.type,
    this.status = ClientStatus.active,
    this.email,
    this.phone,
    this.address,
    this.clientSince,
    this.activeFolders = 0,
    this.totalBilled = 0.0,
    this.notes,
    this.folderIds,
    this.preferredContact,
    this.responsibleLawyer,
    this.customFields,
  });

  // Helper methods
  bool get isActive => status == ClientStatus.active;

  bool get isVip => status == ClientStatus.vip;

  bool get isCorporate => type == ClientType.corporate;

  /// Retorna o número total de pastas/processos vinculados
  int get totalFolders => folderIds?.length ?? 0;

  /// Verifica se o cliente tem múltiplos processos
  bool get hasMultipleFolders => totalFolders > 1;

  /// Retorna o método de contato preferido formatado
  String get displayContact {
    if (preferredContact != null) {
      switch (preferredContact) {
        case 'email':
          return email ?? 'Email não informado';
        case 'phone':
        case 'whatsapp':
          return _formatPhone(phone) ?? 'Telefone não informado';
        default:
          return email ?? _formatPhone(phone) ?? 'Contato não informado';
      }
    }
    return email ?? _formatPhone(phone) ?? 'Contato não informado';
  }

  String? _formatPhone(String? phone) {
    if (phone == null) return null;
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.length == 11) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(
          2, 7)}-${cleanPhone.substring(7)}';
    }
    if (cleanPhone.length == 10) {
      return '(${cleanPhone.substring(0, 2)}) ${cleanPhone.substring(
          2, 6)}-${cleanPhone.substring(6)}';
    }
    return phone;
  }

  String get formattedDocument {
    if (type == ClientType.corporate) {
      // Format CNPJ: XX.XXX.XXX/XXXX-XX
      if (document.length >= 14) {
        return '${document.substring(0, 2)}.${document.substring(
            2, 5)}.${document.substring(5, 8)}/${document.substring(
            8, 12)}-${document.substring(12, 14)}';
      }
    } else {
      // Format CPF: XXX.XXX.XXX-XX
      if (document.length >= 11) {
        return '${document.substring(0, 3)}.${document.substring(
            3, 6)}.${document.substring(6, 9)}-${document.substring(9, 11)}';
      }
    }
    return document;
  }
}
