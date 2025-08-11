import 'dart:math';
import '../../folders/models/folder.dart';
import '../../shared/models/client.dart';
import '../../shared/models/user.dart';
import '../../dashboard/models/task.dart';
import '../../dashboard/models/hearing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../reports/models/area_division_data.dart';
import '../utils/mock_data_generator.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;

  MockDataService._internal();

  final _generator = MockDataGenerator();
  final _random = Random();

  // Stored data for consistency
  late final List<Folder> _folders;
  late final List<Client> _clients;
  late final List<User> _users;
  late final List<Task> _tasks;
  late final List<Hearing> _hearings;
  late final Map<int, List<dynamic>> _folderHistory;
  late final Map<String, dynamic> _dashboardMetrics;
  Map<String, dynamic>? _currentDashboardMetrics;
  bool _isInitialized = false;

  // Initialize data on first access
  void _initializeData() {
    if (_isInitialized) return;

    _clients = _generator.generateClients();
    _users = _generator.generateUsers();
    _folders = _generator.generateFolders(_clients, _users);
    _tasks = _generator.generateTasks(_users, _folders);
    _hearings = _generator.generateHearings(_folders);
    _folderHistory = _generator.generateFolderHistory(_folders, _users);
    _dashboardMetrics =
        _generator.generateDashboardMetrics(_folders, _tasks, _hearings);
    _isInitialized = true;
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
    return _currentDashboardMetrics ?? Map<String, dynamic>.from(_dashboardMetrics);
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

  void _generateFolderHistory(Folder folder) {
    final history = <dynamic>[];
    history.add({
      'id': 1,
      'type': 'Pasta criada',
      'description': 'A pasta foi criada no sistema.',
      'date': folder.createdAt,
      'user': folder.responsibleLawyer.name,
      'attachments': 0,
    });
    _folderHistory[folder.id] = history;
  }

  void _updateDashboardMetrics() {
    _currentDashboardMetrics =
        _generator.generateDashboardMetrics(_folders, _tasks, _hearings);
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

  // Reports data
  List<AreaDivisionData> getAreaDivisionData() {
    // Generate mock area division data
    return [
      AreaDivisionData(
          name: 'Cível', value: 35, color: const Color(0xFF3B82F6)),
      AreaDivisionData(
          name: 'Trabalhista', value: 25, color: const Color(0xFF10B981)),
      AreaDivisionData(
          name: 'Tributário', value: 20, color: const Color(0xFFF59E0B)),
      AreaDivisionData(
          name: 'Criminal', value: 10, color: const Color(0xFFEF4444)),
      AreaDivisionData(
          name: 'Outros', value: 10, color: const Color(0xFF6B7280)),
    ];
  }
}
