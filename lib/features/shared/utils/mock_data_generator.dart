import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../../folders/models/folder.dart';
import '../models/client.dart';
import '../models/user.dart';
import '../../reports/models/area_division_data.dart';

class MockDataGenerator {
  final Faker faker;
  final List<Client> _generatedClients = [];
  final Random _random = Random();

  MockDataGenerator() : faker = Faker();

  User generateUser() {
    final name = faker.person.name();
    final role = [
      'Sócio',
      'Advogado Sênior',
      'Advogado',
      'Advogado Júnior',
      'Estagiário'
    ][_random.nextInt(5)];
    final department = [
      'Cível',
      'Trabalhista',
      'Criminal',
      'Tributário',
      'Família'
    ][_random.nextInt(5)];

    return User(
      id: faker.randomGenerator.integer(1000),
      name: name,
      email: faker.internet.email(),
      role: role,
      department: department,
      avatarUrl: faker.image.loremPicsum(),
    );
  }

  Client generateClient({bool allowExisting = false}) {
    // 60% de chance de reutilizar um cliente existente para simular múltiplos processos por cliente
    if (allowExisting &&
        _generatedClients.isNotEmpty &&
        _random.nextDouble() < 0.6) {
      final existingClient =
          _generatedClients[_random.nextInt(_generatedClients.length)];
      // Atualizar contador de pastas ativas
      return Client(
        id: existingClient.id,
        name: existingClient.name,
        document: existingClient.document,
        type: existingClient.type,
        status: existingClient.status,
        email: existingClient.email,
        phone: existingClient.phone,
        address: existingClient.address,
        clientSince: existingClient.clientSince,
        activeFolders: existingClient.activeFolders + 1,
        totalBilled:
            existingClient.totalBilled + (_random.nextDouble() * 50000),
        notes: existingClient.notes,
        folderIds: [
          ...(existingClient.folderIds ?? []),
          'F${_random.nextInt(10000)}'
        ],
        preferredContact: existingClient.preferredContact,
        responsibleLawyer: existingClient.responsibleLawyer,
        customFields: existingClient.customFields,
      );
    }

    final isCorporate =
        _random.nextDouble() < 0.3; // 30% empresas, 70% pessoa física
    final clientSince = faker.date.dateTime(minYear: 2018, maxYear: 2023);

    // Nomes mais realistas para empresas brasileiras
    final companyNames = [
      'Tech Solutions Ltda',
      'Comercial Nova Era',
      'Indústria Brasileira S.A.',
      'Serviços Especializados ME',
      'Consultoria Empresarial',
      'Transportadora Regional',
      'Construtora Moderna',
      'Farmácia Central',
      'Supermercado Família',
      'Oficina AutoTech',
    ];

    final client = Client(
      id: faker.randomGenerator.integer(9999, min: 1),
      name: isCorporate
          ? companyNames[_random.nextInt(companyNames.length)]
          : faker.person.name(),
      document: isCorporate ? _generateCNPJ() : _generateCPF(),
      type: isCorporate ? ClientType.corporate : ClientType.individual,
      status: _random.nextDouble() < 0.85
          ? ClientStatus.active
          : (_random.nextDouble() < 0.1
              ? ClientStatus.vip
              : ClientStatus.inactive),
      email: faker.internet.email(),
      phone: _generatePhone(),
      address: _generateAddress(),
      clientSince: clientSince,
      activeFolders: 1,
      totalBilled: _random.nextDouble() * (isCorporate ? 500000 : 100000),
      notes: _random.nextBool() ? faker.lorem.sentence() : null,
      folderIds: ['F${_random.nextInt(10000)}'],
      preferredContact: ['email', 'phone', 'whatsapp'][_random.nextInt(3)],
      responsibleLawyer: faker.person.name(),
      customFields: _random.nextBool()
          ? {
              'observacoes': faker.lorem.sentence(),
              'prioridade': ['baixa', 'media', 'alta'][_random.nextInt(3)],
              'origem': [
                'indicacao',
                'site',
                'redes_sociais',
                'marketing'
              ][_random.nextInt(4)],
            }
          : null,
    );

    _generatedClients.add(client);
    return client;
  }

  String _generateCNPJ() {
    return '${_random.nextInt(99).toString().padLeft(2, '0')}.${_random.nextInt(999).toString().padLeft(3, '0')}.${_random.nextInt(999).toString().padLeft(3, '0')}/0001-${_random.nextInt(99).toString().padLeft(2, '0')}';
  }

  String _generateCPF() {
    return '${_random.nextInt(999).toString().padLeft(3, '0')}.${_random.nextInt(999).toString().padLeft(3, '0')}.${_random.nextInt(999).toString().padLeft(3, '0')}-${_random.nextInt(99).toString().padLeft(2, '0')}';
  }

  String _generatePhone() {
    return '(${_random.nextInt(89) + 11}) 9${_random.nextInt(8999) + 1000}-${_random.nextInt(8999) + 1000}';
  }

  String _generateAddress() {
    final streets = [
      'Rua das Flores',
      'Av. Paulista',
      'Rua Augusta',
      'Av. Faria Lima',
      'Rua Oscar Freire'
    ];
    final number = _random.nextInt(999) + 1;
    return '${streets[_random.nextInt(streets.length)]}, $number';
  }

  Folder generateFolder() {
    final client = generateClient(allowExisting: true);
    final area = FolderArea.values[_random.nextInt(FolderArea.values.length)];
    final processTypes = _getProcessTypesForArea(area);
    final processType = processTypes[_random.nextInt(processTypes.length)];

    // Gerar códigos de processo mais realistas
    final year = DateTime.now().year;
    final sequential = _random.nextInt(99999) + 1;
    final processCode =
        '${sequential.toString().padLeft(7, '0')}-${_random.nextInt(99).toString().padLeft(2, '0')}.$year.${_random.nextInt(9) + 1}.${_random.nextInt(99).toString().padLeft(2, '0')}.${_random.nextInt(9999).toString().padLeft(4, '0')}';

    final createdAt = faker.date.dateTime(minYear: 2020, maxYear: 2024);
    final status = _generateRealisticStatus(createdAt);

    return Folder(
      id: faker.randomGenerator.integer(9999, min: 1),
      code: processCode,
      title: processType,
      description: 'Processo de ${area.displayName} para ${client.name}',
      status: status,
      priority: _generatePriority(),
      area: area,
      client: client,
      responsibleLawyer: generateUser(),
      assistantLawyers:
          _random.nextBool() ? [generateUser(), generateUser()] : null,
      createdAt: createdAt,
      updatedAt: _random.nextBool()
          ? faker.date.dateTime(minYear: createdAt.year, maxYear: 2024)
          : null,
      dueDate: _generateDueDate(status, createdAt),
      documentsCount: _random.nextInt(50) + 1,
      isFavorite: _random.nextDouble() < 0.15,
      // 15% de chance de ser favorito
      contractValue: _generateContractValue(area, client.type),
      alreadyBilled: null,
      // Será calculado baseado no contractValue
      courtNumber: _random.nextBool()
          ? '${_random.nextInt(99) + 1}ª Vara ${_getCourtType(area)}'
          : null,
      processNumber: processCode,
      tags: _generateTags(area),
      notes: _random.nextBool() ? faker.lorem.sentence() : null,
    );
  }

  List<String> _getProcessTypesForArea(FolderArea area) {
    switch (area) {
      case FolderArea.civilLitigation:
        return [
          'Ação de Cobrança',
          'Ação de Indenização',
          'Ação de Rescisão Contratual',
          'Execução de Título'
        ];
      case FolderArea.labor:
        return [
          'Reclamação Trabalhista',
          'Acordo Trabalhista',
          'Rescisão Indireta',
          'Horas Extras'
        ];
      case FolderArea.tax:
        return [
          'Restituição de ICMS',
          'Impugnação de Auto de Infração',
          'Parcelamento Fiscal',
          'Revisão de IPTU'
        ];
      case FolderArea.criminal:
        return [
          'Defesa Criminal',
          'Habeas Corpus',
          'Revisão Criminal',
          'Execução Penal'
        ];
      case FolderArea.family:
        return [
          'Divórcio Consensual',
          'Guarda de Menor',
          'Pensão Alimentícia',
          'Inventário'
        ];
      case FolderArea.corporate:
        return [
          'Constituição de Empresa',
          'Fusão Empresarial',
          'Recuperação Judicial',
          'Dissolução de Sociedade'
        ];
      default:
        return [
          'Consultoria Jurídica',
          'Assessoria Legal',
          'Parecer Técnico',
          'Acompanhamento Processual'
        ];
    }
  }

  FolderStatus _generateRealisticStatus(DateTime createdAt) {
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays;

    if (daysSinceCreation < 30) {
      // Processos recentes têm maior chance de estar ativos
      return _random.nextDouble() < 0.8
          ? FolderStatus.active
          : FolderStatus.pending;
    } else if (daysSinceCreation < 365) {
      // Processos de até 1 ano
      final rand = _random.nextDouble();
      if (rand < 0.5) return FolderStatus.active;
      if (rand < 0.8) return FolderStatus.pending;
      if (rand < 0.95) return FolderStatus.completed;
      return FolderStatus.suspended;
    } else {
      // Processos mais antigos têm maior chance de estar concluídos
      final rand = _random.nextDouble();
      if (rand < 0.6) return FolderStatus.completed;
      if (rand < 0.8) return FolderStatus.archived;
      if (rand < 0.95) return FolderStatus.active;
      return FolderStatus.cancelled;
    }
  }

  FolderPriority _generatePriority() {
    final rand = _random.nextDouble();
    if (rand < 0.1) return FolderPriority.urgent;
    if (rand < 0.3) return FolderPriority.high;
    if (rand < 0.7) return FolderPriority.medium;
    return FolderPriority.low;
  }

  DateTime? _generateDueDate(FolderStatus status, DateTime createdAt) {
    if (status == FolderStatus.completed ||
        status == FolderStatus.cancelled ||
        status == FolderStatus.archived) {
      return null;
    }

    final daysToAdd = _random.nextInt(180) + 30; // Entre 30 e 210 dias
    return createdAt.add(Duration(days: daysToAdd));
  }

  double? _generateContractValue(FolderArea area, ClientType clientType) {
    if (_random.nextDouble() < 0.2) return null; // 20% sem valor definido

    double baseValue;
    switch (area) {
      case FolderArea.corporate:
      case FolderArea.tax:
        baseValue = clientType == ClientType.corporate ? 50000 : 15000;
        break;
      case FolderArea.labor:
      case FolderArea.civilLitigation:
        baseValue = clientType == ClientType.corporate ? 25000 : 8000;
        break;
      case FolderArea.family:
      case FolderArea.criminal:
        baseValue = 5000;
        break;
      default:
        baseValue = 10000;
    }

    // Adiciona variação de ±50%
    final variation = ((_random.nextDouble() - 0.5) * baseValue);
    return baseValue + variation;
  }

  String _getCourtType(FolderArea area) {
    switch (area) {
      case FolderArea.labor:
        return 'do Trabalho';
      case FolderArea.family:
        return 'de Família';
      case FolderArea.criminal:
        return 'Criminal';
      case FolderArea.tax:
        return 'da Fazenda Pública';
      default:
        return 'Cível';
    }
  }

  List<String>? _generateTags(FolderArea area) {
    if (_random.nextDouble() < 0.3) return null; // 30% sem tags

    final allTags = [
      'urgente',
      'prioritario',
      'revisao',
      'recurso',
      'acordos',
      'documentacao_pendente',
      'audiencia_marcada',
      'prazo_final',
      'cliente_vip',
      'complexo',
      'rotineiro',
      'negociacao'
    ];

    final numTags = _random.nextInt(4) + 1; // 1 a 4 tags
    final tags = <String>[];

    for (int i = 0; i < numTags; i++) {
      final tag = allTags[_random.nextInt(allTags.length)];
      if (!tags.contains(tag)) {
        tags.add(tag);
      }
    }

    return tags.isEmpty ? null : tags;
  }

  List<Folder> generateFolders(int count) {
    return List.generate(count, (_) => generateFolder());
  }

  List<AreaDivisionData> generateAreaDivisionData() {
    return [
      AreaDivisionData(name: 'Trabalhista', value: 30.0, color: Colors.blue),
      AreaDivisionData(name: 'Penal', value: 25.0, color: Colors.red),
      AreaDivisionData(name: 'Cível', value: 20.0, color: Colors.green),
      AreaDivisionData(
          name: 'Cível Contencioso', value: 15.0, color: Colors.orange),
      AreaDivisionData(name: 'Tributário', value: 10.0, color: Colors.purple),
    ];
  }
}
