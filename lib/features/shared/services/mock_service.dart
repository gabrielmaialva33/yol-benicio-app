// Re-export the enhanced mock data service
export 'mock_data_service.dart';

// This file maintains backward compatibility
import 'mock_data_service.dart';

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
}
