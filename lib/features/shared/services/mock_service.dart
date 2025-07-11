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
  
  Task createTask(Map<String, dynamic> data) => _dataService.createTask(data);
  
  void updateTask(int id, Map<String, dynamic> updates) => _dataService.updateTask(id, updates);
  
  // Search
  List<dynamic> search(String query) => _dataService.search(query);
  
  // Reports data
  List<AreaDivisionData> getAreaDivisionData() {
    // Generate mock area division data
    return [
      AreaDivisionData(area: 'Cível', percentage: 35, count: 420, color: const Color(0xFF3B82F6)),
      AreaDivisionData(area: 'Trabalhista', percentage: 25, count: 300, color: const Color(0xFF10B981)),
      AreaDivisionData(area: 'Tributário', percentage: 20, count: 240, color: const Color(0xFFF59E0B)),
      AreaDivisionData(area: 'Criminal', percentage: 10, count: 120, color: const Color(0xFFEF4444)),
      AreaDivisionData(area: 'Outros', percentage: 10, count: 120, color: const Color(0xFF6B7280)),
    ];
  }
}
