// Re-export the enhanced mock data service
export 'mock_data_service.dart';

// This file maintains backward compatibility
import 'package:flutter/material.dart';
import 'mock_data_service.dart';
import '../../folders/models/folder.dart';
import '../models/client.dart';
import '../models/user.dart';
import '../../dashboard/models/task.dart';
import '../../dashboard/models/hearing.dart';
import '../../reports/models/area_division_data.dart';

class MockService {
  final _dataService = MockDataService();

  // Delegate all calls to the enhanced service
  List<Folder> getFolders(int count) {
    final folders = _dataService.getFolders();
    return folders.take(count).toList();
  }

  List<Client> getClients() => _dataService.getClients();

  List<User> getUsers() => _dataService.getUsers();

  List<Task> getTasks() => _dataService.getTasks();

  List<Hearing> getHearings() => _dataService.getHearings();

  Map<String, dynamic> getDashboardMetrics() => _dataService.getDashboardMetrics();

  List<dynamic> getFolderHistory(int folderId) => _dataService.getFolderHistory(folderId);

  // CRUD operations
  Folder createFolder(Map<String, dynamic> data) => _dataService.createFolder(data);

  Folder updateFolder(int id, Map<String, dynamic> updates) => _dataService.updateFolder(id, updates);

  void deleteFolder(int id) => _dataService.deleteFolder(id);
  
  Client createClient(Client client) => _dataService.createClient(client);
  
  Task createTask(Map<String, dynamic> data) => _dataService.createTask(data);
  
  void updateTask(int id, Map<String, dynamic> updates) => _dataService.updateTask(id, updates);
  
  // Search
  List<dynamic> search(String query) => _dataService.search(query);

  // Reports data
  List<AreaDivisionData> getAreaDivisionData() {
    // Generate mock area division data
    return [
      AreaDivisionData(name: 'Cível', value: 35, color: const Color(0xFF3B82F6)),
      AreaDivisionData(name: 'Trabalhista', value: 25, color: const Color(0xFF10B981)),
      AreaDivisionData(name: 'Tributário', value: 20, color: const Color(0xFFF59E0B)),
      AreaDivisionData(name: 'Criminal', value: 10, color: const Color(0xFFEF4444)),
      AreaDivisionData(name: 'Outros', value: 10, color: const Color(0xFF6B7280)),
    ];
  }
}
