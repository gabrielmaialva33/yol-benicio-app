import 'dart:math';
import 'package:benicio/features/dashboard/models/hearing.dart';
import 'package:benicio/features/dashboard/models/task.dart';
import 'package:benicio/features/folders/models/folder.dart';
import 'package:benicio/features/shared/models/client.dart';
import 'package:benicio/features/shared/models/user.dart';
import 'package:faker/faker.dart';

class MockDataGenerator {
  final Faker _faker = Faker();
  final Random _random = Random();

  List<Client> generateClients() {
    final clients = <Client>[];
    final clientNames = [
      'Empresa ABC Ltda',
      'João Silva',
      'Maria Santos',
      'Tech Solutions S.A.',
      'Ana Costa',
      'Pedro Oliveira',
      'Grupo Empresarial XYZ',
      'Carlos Ferreira',
      'Juliana Rodrigues',
      'Construtora Beta',
      'Rafael Almeida',
      'Fernanda Lima',
      'Indústria Gama',
      'Lucas Martins',
      'Patrícia Souza',
    ];

    for (int i = 0; i < clientNames.length; i++) {
      final isCorporate = clientNames[i].contains('Ltda') ||
          clientNames[i].contains('S.A.') ||
          clientNames[i].contains('Grupo') ||
          clientNames[i].contains('Construtora') ||
          clientNames[i].contains('Indústria');

      clients.add(Client(
        id: i + 1,
        name: clientNames[i],
        document: isCorporate
            ? _faker.randomGenerator.fromPattern(['##############'])
            : _faker.randomGenerator.fromPattern(['###########']),
        type: isCorporate ? ClientType.corporate : ClientType.individual,
        status: _random.nextDouble() > 0.8
            ? ClientStatus.vip
            : _random.nextDouble() > 0.9
                ? ClientStatus.inactive
                : ClientStatus.active,
        email: _faker.internet.email(),
        phone: _faker.phoneNumber.us(),
        address: '${_faker.address.streetAddress()}, ${_faker.address.city()}',
        clientSince: DateTime.now().subtract(
          Duration(days: _random.nextInt(1825) + 365), // 1-6 anos
        ),
        activeFolders: _random.nextInt(15) + 1,
        totalBilled: _random.nextDouble() * 500000 + 10000,
        preferredContact: ['email', 'phone', 'whatsapp'][_random.nextInt(3)],
        responsibleLawyer: 'Dr. ${_faker.person.name()}',
      ));
    }
    return clients;
  }

  List<User> generateUsers() {
    final users = <User>[];
    final roles = [
      'Sócio',
      'Advogado Sênior',
      'Advogado Pleno',
      'Advogado Júnior',
      'Estagiário'
    ];

    for (int i = 0; i < 15; i++) {
      users.add(User(
        id: i + 1,
        name: 'Dr. ${_faker.person.name()}',
        email: _faker.internet.email(),
        role: roles[_random.nextInt(roles.length)],
        department: FolderArea
            .values[_random.nextInt(FolderArea.values.length)].displayName,
        isActive: _random.nextDouble() > 0.1,
        photoUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
      ));
    }
    return users;
  }

  List<Folder> generateFolders(List<Client> clients, List<User> users) {
    final folders = <Folder>[];
    final processTypes = [
      'Ação de Cobrança',
      'Reclamação Trabalhista',
      'Execução Fiscal',
      'Mandado de Segurança',
      'Ação de Indenização',
      'Recurso Especial',
      'Agravo de Instrumento',
      'Ação Revisional',
      'Cumprimento de Sentença',
      'Ação Cautelar',
    ];

    for (int i = 0; i < 50; i++) {
      final client = clients[_random.nextInt(clients.length)];
      final responsibleLawyer = users[_random.nextInt(users.length)];
      final area = FolderArea.values[_random.nextInt(FolderArea.values.length)];

      final folder = Folder(
        id: i + 1,
        code:
            'PROC-${DateTime.now().year}-${(i + 1).toString().padLeft(4, '0')}',
        title:
            '${processTypes[_random.nextInt(processTypes.length)]} - ${client.name}',
        description: _faker.lorem.sentences(3).join(' '),
        status:
            FolderStatus.values[_random.nextInt(FolderStatus.values.length)],
        priority: FolderPriority
            .values[_random.nextInt(FolderPriority.values.length)],
        area: area,
        client: client,
        responsibleLawyer: responsibleLawyer,
        assistantLawyers: _random.nextBool()
            ? users
                .where((u) => u.id != responsibleLawyer.id)
                .take(_random.nextInt(3) + 1)
                .toList()
            : null,
        createdAt:
            DateTime.now().subtract(Duration(days: _random.nextInt(730))),
        updatedAt: _random.nextBool()
            ? DateTime.now().subtract(Duration(days: _random.nextInt(30)))
            : null,
        dueDate: _random.nextBool()
            ? DateTime.now().add(Duration(days: _random.nextInt(90) - 30))
            : null,
        documentsCount: _random.nextInt(50) + 5,
        isFavorite: _random.nextDouble() > 0.8,
        contractValue:
            _random.nextBool() ? _random.nextDouble() * 100000 + 5000 : null,
        alreadyBilled: _random.nextBool() && _random.nextBool()
            ? _random.nextDouble() * 50000
            : null,
        courtNumber: '${_random.nextInt(30) + 1}ª Vara ${area.displayName}',
        processNumber:
            '${_random.nextInt(9999999).toString().padLeft(7, '0')}-${_random.nextInt(99)}.${DateTime.now().year}.8.26.0100',
        tags: _random.nextBool()
            ? List.generate(_random.nextInt(4) + 1, (_) => _faker.lorem.word())
            : null,
      );
      folders.add(folder);
    }
    return folders;
  }

  Map<int, List<dynamic>> generateFolderHistory(
      List<Folder> folders, List<User> users) {
    final folderHistory = <int, List<dynamic>>{};
    for (final folder in folders) {
      final historyTypes = [
        'Petição inicial protocolada',
        'Contestação apresentada',
        'Audiência realizada',
        'Sentença proferida',
        'Recurso interposto',
        'Documentos juntados',
        'Despacho judicial',
        'Citação realizada',
        'Perícia agendada',
        'Acordo proposto',
      ];

      final historyCount = _random.nextInt(15) + 5;
      final history = <dynamic>[];
      final daysSinceCreation =
          DateTime.now().difference(folder.createdAt).inDays;
      if (daysSinceCreation < 1) {
        history.add({
          'id': 1,
          'type': 'Pasta criada',
          'description': 'A pasta foi criada no sistema.',
          'date': folder.createdAt,
          'user': folder.responsibleLawyer.name,
          'attachments': 0,
        });
        folderHistory[folder.id] = history;
        continue;
      }

      for (int i = 0; i < historyCount; i++) {
        final date = folder.createdAt
            .add(Duration(days: _random.nextInt(daysSinceCreation)));

        history.add({
          'id': i + 1,
          'type': historyTypes[_random.nextInt(historyTypes.length)],
          'description': _faker.lorem.sentences(2).join(' '),
          'date': date,
          'user': users[_random.nextInt(users.length)].name,
          'attachments': _random.nextBool() ? _random.nextInt(5) + 1 : 0,
        });
      }

      history.sort((a, b) => b['date'].compareTo(a['date']));
      folderHistory[folder.id] = history;
    }
    return folderHistory;
  }

  List<Task> generateTasks(List<User> users, List<Folder> folders) {
    final tasks = <Task>[];
    final taskTypes = [
      'Elaborar petição',
      'Revisar contrato',
      'Preparar defesa',
      'Analisar documentos',
      'Reunião com cliente',
      'Audiência',
      'Prazo processual',
      'Emitir parecer',
    ];

    for (int i = 0; i < 20; i++) {
      tasks.add(Task(
        id: i + 1,
        title: taskTypes[_random.nextInt(taskTypes.length)],
        description: _faker.lorem.sentence(),
        dueDate: DateTime.now().add(Duration(days: _random.nextInt(30) - 10)),
        priority:
            TaskPriority.values[_random.nextInt(TaskPriority.values.length)],
        status: TaskStatus.values[_random.nextInt(TaskStatus.values.length)],
        assignedTo: users[_random.nextInt(users.length)],
        folder: _random.nextBool()
            ? folders[_random.nextInt(folders.length)]
            : null,
      ));
    }
    return tasks;
  }

  List<Hearing> generateHearings(List<Folder> folders) {
    final hearings = <Hearing>[];
    final hearingTypes = [
      'Audiência de Conciliação',
      'Audiência de Instrução',
      'Audiência de Julgamento',
      'Audiência Una',
      'Sessão de Julgamento',
    ];

    for (int i = 0; i < 15; i++) {
      final folder = folders[_random.nextInt(folders.length)];
      hearings.add(Hearing(
        id: i + 1,
        type: hearingTypes[_random.nextInt(hearingTypes.length)],
        dateTime: DateTime.now().add(Duration(days: _random.nextInt(60) - 20)),
        location:
            '${_random.nextInt(30) + 1}ª Vara - Fórum ${_faker.address.city()}',
        folder: folder,
        judge: 'Dr. ${_faker.person.name()}',
        notes: _random.nextBool() ? _faker.lorem.sentence() : null,
      ));
    }
    return hearings;
  }

  Map<String, dynamic> generateDashboardMetrics(
      List<Folder> folders, List<Task> tasks, List<Hearing> hearings) {
    final activeFolders =
        folders.where((f) => f.status == FolderStatus.active).length;
    final completedFolders =
        folders.where((f) => f.status == FolderStatus.completed).length;
    final totalFolders = folders.length;
    final deliveredFolders = folders
        .where((f) => f.status == FolderStatus.completed && !f.isOverdue)
        .length;
    final delayedFolders = folders.where((f) => f.isOverdue).length;

    return {
      'activeFolders': activeFolders,
      'completedFolders': completedFolders,
      'totalFolders': totalFolders,
      'deliveredFolders': deliveredFolders,
      'delayedFolders': delayedFolders,
      'newThisMonth': folders
          .where((f) => f.createdAt
              .isAfter(DateTime.now().subtract(const Duration(days: 30))))
          .length,
      'totalRevenue': folders
          .where((f) => f.contractValue != null)
          .fold<double>(0, (sum, f) => sum + f.contractValue!),
      'pendingTasks':
          tasks.where((t) => t.status != TaskStatus.completed).length,
      'upcomingHearings':
          hearings.where((h) => h.dateTime.isAfter(DateTime.now())).length,
    };
  }
}
