import '../utils/mock_data_generator.dart';
import '../../folders/models/folder.dart';
import '../../reports/models/area_division_data.dart';

class MockService {
  final MockDataGenerator _generator = MockDataGenerator();

  List<Folder> getFolders(int count) {
    return _generator.generateFolders(count);
  }

  List<AreaDivisionData> getAreaDivisionData() {
    return _generator.generateAreaDivisionData();
  }
}
