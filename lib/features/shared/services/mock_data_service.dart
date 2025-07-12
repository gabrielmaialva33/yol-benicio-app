import 'dart:math';
import 'package:faker/faker.dart';
import '../../folders/models/folder.dart';
import '../../shared/models/client.dart';
import '../../shared/models/user.dart';
import '../../dashboard/models/task.dart';
import '../../dashboard/models/hearing.dart';
import 'package:fl_chart/fl_chart.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final _faker = Faker();
  final _random = Random();

  // Stored data for consistency
  final List<Folder> _folders = [];
  final List<Client> _clients = [];
  final List<User> _users = [];
  final List<Task> _tasks = [];
  final List<Hearing> _hearings = [];
  final Map<int, List<dynamic>> _folderHistory = {};
  final Map<String, dynamic> _dashboardMetrics = {};

  // Initialize data on first access
  void _initializeData() {
    if (_clients.isEmpty) {
      _generateClients();
    }
    if (_users.isEmpty) {
      _generateUsers();
    }
    if (_folders.isEmpty) {
      _generateFolders();
    }
    if (_tasks.isEmpty) {
      _generateTasks();
    }
    if (_hearings.isEmpty) {
      _generateHearings();
    }
    if (_dashboardMetrics.isEmpty) {
      _generateDashboardMetrics();
    }
  }

  // Generate mock clients
  void _generateClients() {
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

      _clients.add(Client(
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
  }

  // Generate mock users (lawyers)
  void _generateUsers() {
    final roles = [
      'Sócio',
      'Advogado Sênior',
      'Advogado Pleno',
      'Advogado Júnior',
      'Estagiário'
    ];

    for (int i = 0; i < 15; i++) {
      _users.add(User(
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
  }

  // Generate mock folders
  void _generateFolders() {
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
      final client = _clients[_random.nextInt(_clients.length)];
      final responsibleLawyer = _users[_random.nextInt(_users.length)];
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
            ? _users
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

      _folders.add(folder);
      _generateFolderHistory(folder);
    }
  }

  // Generate folder history
  void _generateFolderHistory(Folder folder) {
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

    for (int i = 0; i < historyCount; i++) {
      final date = folder.createdAt.add(Duration(
          days: _random
              .nextInt(DateTime.now().difference(folder.createdAt).inDays)));

      history.add({
        'id': i + 1,
        'type': historyTypes[_random.nextInt(historyTypes.length)],
        'description': _faker.lorem.sentences(2).join(' '),
        'date': date,
        'user': _users[_random.nextInt(_users.length)].name,
        'attachments': _random.nextBool() ? _random.nextInt(5) + 1 : 0,
      });
    }

    history.sort((a, b) => b['date'].compareTo(a['date']));
    _folderHistory[folder.id] = history;
  }

  // Generate tasks
  void _generateTasks() {
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
      _tasks.add(Task(
        id: i + 1,
        title: taskTypes[_random.nextInt(taskTypes.length)],
        description: _faker.lorem.sentence(),
        dueDate: DateTime.now().add(Duration(days: _random.nextInt(30) - 10)),
        priority:
            TaskPriority.values[_random.nextInt(TaskPriority.values.length)],
        status: TaskStatus.values[_random.nextInt(TaskStatus.values.length)],
        assignedTo: _users[_random.nextInt(_users.length)],
        folder: _random.nextBool()
            ? _folders[_random.nextInt(_folders.length)]
            : null,
      ));
    }
  }

  // Generate hearings
  void _generateHearings() {
    final hearingTypes = [
      'Audiência de Conciliação',
      'Audiência de Instrução',
      'Audiência de Julgamento',
      'Audiência Una',
      'Sessão de Julgamento',
    ];

    for (int i = 0; i < 15; i++) {
      final folder = _folders[_random.nextInt(_folders.length)];
      _hearings.add(Hearing(
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
  }

  // Generate dashboard metrics
  void _generateDashboardMetrics() {
    final activeFolders =
        _folders.where((f) => f.status == FolderStatus.active).length;
    final completedFolders =
        _folders.where((f) => f.status == FolderStatus.completed).length;
    final totalFolders = _folders.length;
    final deliveredFolders = _folders
        .where((f) => f.status == FolderStatus.completed && !f.isOverdue)
        .length;
    final delayedFolders = _folders.where((f) => f.isOverdue).length;

    _dashboardMetrics['activeFolders'] = activeFolders;
    _dashboardMetrics['completedFolders'] = completedFolders;
    _dashboardMetrics['totalFolders'] = totalFolders;
    _dashboardMetrics['deliveredFolders'] = deliveredFolders;
    _dashboardMetrics['delayedFolders'] = delayedFolders;
    _dashboardMetrics['newThisMonth'] = _folders
        .where((f) =>
            f.createdAt.isAfter(DateTime.now().subtract(Duration(days: 30))))
        .length;
    _dashboardMetrics['totalRevenue'] = _folders
        .where((f) => f.contractValue != null)
        .fold<double>(0, (sum, f) => sum + f.contractValue!);
    _dashboardMetrics['pendingTasks'] =
        _tasks.where((t) => t.status != TaskStatus.completed).length;
    _dashboardMetrics['upcomingHearings'] =
        _hearings.where((h) => h.dateTime.isAfter(DateTime.now())).length;
  }

  // Public methods to access data
  List<Folder> getFolders(
      {String? search, FolderStatus? status, int? clientId}) {
    _initializeData();

    var result = List<Folder>.from(_folders);

    if (search != null && search.isNotEmpty) {
      result = result
          .where((f) =>
              f.title.toLowerCase().contains(search.toLowerCase()) ||
              f.client.name.toLowerCase().contains(search.toLowerCase()) ||
              f.code.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    if (status != null) {
      result = result.where((f) => f.status == status).toList();
    }

    if (clientId != null) {
      result = result.where((f) => f.client.id == clientId).toList();
    }

    return result;
  }

  List<Client> getClients() {
    _initializeData();
    return List<Client>.from(_clients);
  }

  List<User> getUsers() {
    _initializeData();
    return List<User>.from(_users);
  }

  List<Task> getTasks({TaskStatus? status, int? userId}) {
    _initializeData();

    var result = List<Task>.from(_tasks);

    if (status != null) {
      result = result.where((t) => t.status == status).toList();
    }

    if (userId != null) {
      result = result.where((t) => t.assignedTo.id == userId).toList();
    }

    return result;
  }

  List<Hearing> getHearings({DateTime? fromDate, DateTime? toDate}) {
    _initializeData();

    var result = List<Hearing>.from(_hearings);

    if (fromDate != null) {
      result = result.where((h) => h.dateTime.isAfter(fromDate)).toList();
    }

    if (toDate != null) {
      result = result.where((h) => h.dateTime.isBefore(toDate)).toList();
    }

    result.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return result;
  }

  Map<String, dynamic> getDashboardMetrics() {
    _initializeData();
    return Map<String, dynamic>.from(_dashboardMetrics);
  }

  List<dynamic> getFolderHistory(int folderId) {
    _initializeData();
    return _folderHistory[folderId] ?? [];
  }

  // CRUD Operations
  Folder createFolder(Map<String, dynamic> data) {
    _initializeData();

    final newFolder = Folder(
      id: _folders.length + 1,
      code:
          'PROC-${DateTime.now().year}-${(_folders.length + 1).toString().padLeft(4, '0')}',
      title: data['title'],
      description: data['description'],
      status: data['status'] ?? FolderStatus.active,
      priority: data['priority'] ?? FolderPriority.medium,
      area: data['area'],
      client: data['client'],
      responsibleLawyer: data['responsibleLawyer'],
      createdAt: DateTime.now(),
      documentsCount: 0,
      contractValue: data['contractValue'],
      dueDate: data['dueDate'],
      processNumber: data['processNumber'],
      courtNumber: data['courtNumber'],
    );

    _folders.add(newFolder);
    _generateFolderHistory(newFolder);
    _updateDashboardMetrics();

    return newFolder;
  }

  Folder updateFolder(int id, Map<String, dynamic> updates) {
    _initializeData();

    final index = _folders.indexWhere((f) => f.id == id);
    if (index == -1) throw Exception('Folder not found');

    final oldFolder = _folders[index];
    final updatedFolder = Folder(
      id: oldFolder.id,
      code: oldFolder.code,
      title: updates['title'] ?? oldFolder.title,
      description: updates['description'] ?? oldFolder.description,
      status: updates['status'] ?? oldFolder.status,
      priority: updates['priority'] ?? oldFolder.priority,
      area: updates['area'] ?? oldFolder.area,
      client: updates['client'] ?? oldFolder.client,
      responsibleLawyer:
          updates['responsibleLawyer'] ?? oldFolder.responsibleLawyer,
      assistantLawyers:
          updates['assistantLawyers'] ?? oldFolder.assistantLawyers,
      createdAt: oldFolder.createdAt,
      updatedAt: DateTime.now(),
      dueDate: updates['dueDate'] ?? oldFolder.dueDate,
      documentsCount: updates['documentsCount'] ?? oldFolder.documentsCount,
      isFavorite: updates['isFavorite'] ?? oldFolder.isFavorite,
      contractValue: updates['contractValue'] ?? oldFolder.contractValue,
      alreadyBilled: updates['alreadyBilled'] ?? oldFolder.alreadyBilled,
      courtNumber: updates['courtNumber'] ?? oldFolder.courtNumber,
      processNumber: updates['processNumber'] ?? oldFolder.processNumber,
      tags: updates['tags'] ?? oldFolder.tags,
      notes: updates['notes'] ?? oldFolder.notes,
    );

    _folders[index] = updatedFolder;
    _updateDashboardMetrics();

    return updatedFolder;
  }

  void deleteFolder(int id) {
    _initializeData();
    _folders.removeWhere((f) => f.id == id);
    _folderHistory.remove(id);
    _updateDashboardMetrics();
  }

  Client createClient(Client newClient) {
    _initializeData();
    _clients.add(newClient);
    return newClient;
  }

  Task createTask(Map<String, dynamic> data) {
    _initializeData();

    final newTask = Task(
      id: _tasks.length + 1,
      title: data['title'],
      description: data['description'],
      dueDate: data['dueDate'],
      priority: data['priority'] ?? TaskPriority.medium,
      status: data['status'] ?? TaskStatus.pending,
      assignedTo: data['assignedTo'],
      folder: data['folder'],
    );

    _tasks.add(newTask);
    return newTask;
  }

  void updateTask(int id, Map<String, dynamic> updates) {
    _initializeData();

    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final oldTask = _tasks[index];
    _tasks[index] = Task(
      id: oldTask.id,
      title: updates['title'] ?? oldTask.title,
      description: updates['description'] ?? oldTask.description,
      dueDate: updates['dueDate'] ?? oldTask.dueDate,
      priority: updates['priority'] ?? oldTask.priority,
      status: updates['status'] ?? oldTask.status,
      assignedTo: updates['assignedTo'] ?? oldTask.assignedTo,
      folder: updates['folder'] ?? oldTask.folder,
    );
  }

  void _updateDashboardMetrics() {
    _generateDashboardMetrics();
  }

  // Generate chart data
  List<FlSpot> generateChartData(int points) {
    final spots = <FlSpot>[];
    double lastValue = _random.nextDouble() * 3 + 1;

    for (int i = 0; i < points; i++) {
      lastValue += (_random.nextDouble() - 0.5) * 2;
      lastValue = lastValue.clamp(0, 5);
      spots.add(FlSpot(i.toDouble(), lastValue));
    }

    return spots;
  }

  // Search functionality
  List<dynamic> search(String query) {
    _initializeData();

    final results = <dynamic>[];
    final lowerQuery = query.toLowerCase();

    // Search folders
    results.addAll(_folders.where((f) =>
        f.title.toLowerCase().contains(lowerQuery) ||
        f.code.toLowerCase().contains(lowerQuery) ||
        f.client.name.toLowerCase().contains(lowerQuery)));

    // Search clients
    results.addAll(_clients.where((c) =>
        c.name.toLowerCase().contains(lowerQuery) ||
        c.document.contains(query)));

    // Search tasks
    results.addAll(_tasks.where((t) =>
        t.title.toLowerCase().contains(lowerQuery) ||
        t.description.toLowerCase().contains(lowerQuery)));

    return results;
  }
}
