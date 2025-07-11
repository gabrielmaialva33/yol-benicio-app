import 'dart:math';
import '../utils/mock_data_generator.dart';
import '../../folders/models/folder.dart';
import '../../reports/models/area_division_data.dart';
import '../../../core/theme/app_theme.dart';

// Modelos para dados mais realistas
class LawyerProfile {
  final String name;
  final String oab;
  final String specialization;
  final String email;
  final String phone;
  final int activeCases;
  final int totalCases;
  final double successRate;
  final DateTime joinDate;

  LawyerProfile({
    required this.name,
    required this.oab,
    required this.specialization,
    required this.email,
    required this.phone,
    required this.activeCases,
    required this.totalCases,
    required this.successRate,
    required this.joinDate,
  });
}

class CaseMetrics {
  final int totalCases;
  final int activeCases;
  final int closedCases;
  final int wonCases;
  final int lostCases;
  final int pendingHearings;
  final int overdueDeadlines;
  final double averageCaseDuration;
  final double monthlyRevenue;
  final Map<String, int> casesByArea;
  final Map<String, double> revenueByArea;

  CaseMetrics({
    required this.totalCases,
    required this.activeCases,
    required this.closedCases,
    required this.wonCases,
    required this.lostCases,
    required this.pendingHearings,
    required this.overdueDeadlines,
    required this.averageCaseDuration,
    required this.monthlyRevenue,
    required this.casesByArea,
    required this.revenueByArea,
  });
}

class ClientData {
  final String name;
  final String document;
  final String email;
  final String phone;
  final String address;
  final int activeCases;
  final double totalBilled;
  final DateTime clientSince;
  final String status; // 'active', 'inactive', 'vip'

  ClientData({
    required this.name,
    required this.document,
    required this.email,
    required this.phone,
    required this.address,
    required this.activeCases,
    required this.totalBilled,
    required this.clientSince,
    required this.status,
  });
}

class MockService {
  final MockDataGenerator _generator = MockDataGenerator();
  static final Random _random = Random();

  final List<String> _realClientNames = [
    'João Silva & Cia Ltda',
    'Maria Santos Comércio',
    'Carlos Oliveira ME',
    'Ana Costa Consultoria',
    'Pedro Almeida Indústria',
    'Lucia Ferreira & Associados',
    'Roberto Lima Transportes',
    'Fernanda Souza Serviços',
    'Gabriel Rodrigues Tech',
    'Patricia Mendes Educação',
    'Ricardo Pereira Construção',
    'Juliana Barbosa Fashion',
    'Marcos Cardoso Alimentação',
    'Tatiana Araújo Saúde',
    'Rafael Nascimento Logística',
  ];

  List<Folder> getFolders(int count) {
    return _generator.generateFolders(count);
  }

  List<AreaDivisionData> getAreaDivisionData() {
    return [
      AreaDivisionData(
          name: 'Trabalhista', value: 28.5, color: AppTheme.trabalhista),
      AreaDivisionData(
          name: 'Tributário', value: 22.3, color: AppTheme.tributario),
      AreaDivisionData(name: 'Civil', value: 18.7, color: AppTheme.civil),
      AreaDivisionData(name: 'Penal', value: 15.2, color: AppTheme.penal),
      AreaDivisionData(
          name: 'Empresarial', value: 10.8, color: AppTheme.empresarial),
      AreaDivisionData(
          name: 'Contencioso', value: 4.5, color: AppTheme.contencioso),
    ];
  }

  CaseMetrics getCaseMetrics() {
    return CaseMetrics(
      totalCases: 2847,
      activeCases: 1256,
      closedCases: 1591,
      wonCases: 1203,
      lostCases: 235,
      pendingHearings: 89,
      overdueDeadlines: 23,
      averageCaseDuration: 8.5,
      monthlyRevenue: 850000.0,
      casesByArea: {
        'Trabalhista': 812,
        'Tributário': 635,
        'Civil': 532,
        'Penal': 433,
        'Empresarial': 308,
        'Outros': 127,
      },
      revenueByArea: {
        'Trabalhista': 245000.0,
        'Tributário': 190000.0,
        'Civil': 158000.0,
        'Penal': 129000.0,
        'Empresarial': 92000.0,
        'Outros': 36000.0,
      },
    );
  }

  List<LawyerProfile> getLawyers() {
    return [
      LawyerProfile(
        name: 'Dr. Eduardo Benício',
        oab: 'OAB/SP 123.456',
        specialization: 'Direito Empresarial e Tributário',
        email: 'eduardo@benicio.adv.br',
        phone: '(11) 99999-8888',
        activeCases: 145,
        totalCases: 523,
        successRate: 94.2,
        joinDate: DateTime(2018, 3, 15),
      ),
      LawyerProfile(
        name: 'Dra. Mariana Silva',
        oab: 'OAB/SP 234.567',
        specialization: 'Direito Trabalhista',
        email: 'mariana@benicio.adv.br',
        phone: '(11) 99999-7777',
        activeCases: 203,
        totalCases: 687,
        successRate: 91.8,
        joinDate: DateTime(2019, 8, 22),
      ),
      LawyerProfile(
        name: 'Dr. Carlos Mendes',
        oab: 'OAB/SP 345.678',
        specialization: 'Direito Penal',
        email: 'carlos@benicio.adv.br',
        phone: '(11) 99999-6666',
        activeCases: 89,
        totalCases: 312,
        successRate: 87.5,
        joinDate: DateTime(2020, 1, 10),
      ),
      LawyerProfile(
        name: 'Dra. Ana Rodrigues',
        oab: 'OAB/SP 456.789',
        specialization: 'Direito Civil e Família',
        email: 'ana@benicio.adv.br',
        phone: '(11) 99999-5555',
        activeCases: 167,
        totalCases: 445,
        successRate: 92.7,
        joinDate: DateTime(2019, 5, 3),
      ),
    ];
  }

  List<ClientData> getTopClients() {
    return _realClientNames.take(10).map((name) {
      return ClientData(
        name: name,
        document: _generateDocument(),
        email: _generateEmail(name),
        phone: _generatePhone(),
        address: _generateAddress(),
        activeCases: _random.nextInt(15) + 1,
        totalBilled: (_random.nextDouble() * 500000) + 50000,
        clientSince:
            DateTime.now().subtract(Duration(days: _random.nextInt(1825))),
        status: _random.nextBool()
            ? 'active'
            : (_random.nextBool() ? 'vip' : 'inactive'),
      );
    }).toList();
  }

  Map<String, dynamic> getFinancialMetrics() {
    return {
      'monthly_revenue': 850000.0,
      'last_month_revenue': 782000.0,
      'growth_percentage': 8.7,
      'pending_receivables': 125000.0,
      'overdue_receivables': 35000.0,
      'average_case_value': 15500.0,
      'total_yearly_revenue': 9840000.0,
      'revenue_by_month': [
        {'month': 'Jan', 'value': 720000},
        {'month': 'Fev', 'value': 765000},
        {'month': 'Mar', 'value': 832000},
        {'month': 'Abr', 'value': 798000},
        {'month': 'Mai', 'value': 845000},
        {'month': 'Jun', 'value': 782000},
        {'month': 'Jul', 'value': 850000},
      ],
    };
  }

  List<Map<String, dynamic>> getRecentActivities() {
    return [
      {
        'type': 'hearing',
        'description': 'Audiência agendada - Processo 1234567-89',
        'client': 'João Silva & Cia Ltda',
        'lawyer': 'Dra. Mariana Silva',
        'date': DateTime.now().add(const Duration(days: 3)),
        'priority': 'high',
      },
      {
        'type': 'deadline',
        'description': 'Prazo para recurso vencendo',
        'client': 'Maria Santos Comércio',
        'lawyer': 'Dr. Carlos Mendes',
        'date': DateTime.now().add(const Duration(days: 2)),
        'priority': 'urgent',
      },
      {
        'type': 'document',
        'description': 'Petição inicial protocolada',
        'client': 'Pedro Almeida Indústria',
        'lawyer': 'Dr. Eduardo Benício',
        'date': DateTime.now().subtract(const Duration(hours: 4)),
        'priority': 'normal',
      },
      {
        'type': 'payment',
        'description': 'Honorários recebidos - R\$ 25.000,00',
        'client': 'Ana Costa Consultoria',
        'lawyer': 'Dra. Ana Rodrigues',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'priority': 'normal',
      },
    ];
  }

  List<Map<String, dynamic>> getUpcomingDeadlines() {
    return [
      {
        'case_number': '1001234-67.2024.5.02.0001',
        'description': 'Recurso Ordinário',
        'deadline': DateTime.now().add(const Duration(days: 1)),
        'client': 'João Silva & Cia Ltda',
        'priority': 'urgent',
        'area': 'Trabalhista',
      },
      {
        'case_number': '2002345-78.2024.4.03.0002',
        'description': 'Contestação',
        'deadline': DateTime.now().add(const Duration(days: 3)),
        'client': 'Maria Santos Comércio',
        'priority': 'high',
        'area': 'Civil',
      },
      {
        'case_number': '3003456-89.2024.8.26.0003',
        'description': 'Alegações Finais',
        'deadline': DateTime.now().add(const Duration(days: 7)),
        'client': 'Carlos Oliveira ME',
        'priority': 'medium',
        'area': 'Penal',
      },
    ];
  }

  // Método de busca para a SearchPage
  List<Map<String, dynamic>> searchItems(String query, String category) {
    final List<Map<String, dynamic>> allItems = [
      // Clientes
      ...List.generate(
          20,
          (index) => {
                'type': 'client',
                'title': 'João Silva ${index + 1}',
                'subtitle': 'Cliente desde ${2020 + (index % 5)}',
                'category': 'Clientes',
              }),
      // Processos
      ...List.generate(
          15,
          (index) => {
                'type': 'process',
                'title': 'Processo ${100000 + index}',
                'subtitle': 'Direito Civil • Em andamento',
                'category': 'Processos',
              }),
      // Documentos
      ...List.generate(
          25,
          (index) => {
                'type': 'document',
                'title': 'Contrato ${index + 1}',
                'subtitle':
                    'Documento criado em ${DateTime.now().subtract(Duration(days: index * 5)).day}/${DateTime.now().month}',
                'category': 'Documentos',
              }),
      // Pastas
      ...List.generate(
          10,
          (index) => {
                'type': 'folder',
                'title': 'Pasta ${index + 1}',
                'subtitle': 'Processo familiar • Ativa',
                'category': 'Pastas Ativas',
              }),
    ];

    // Filtrar por categoria
    List<Map<String, dynamic>> filteredByCategory = category == 'Todos'
        ? allItems
        : allItems
            .where((item) =>
                item['category']
                    .toString()
                    .toLowerCase()
                    .contains(category.toLowerCase()) ||
                item['type']
                    .toString()
                    .toLowerCase()
                    .contains(category.toLowerCase()))
            .toList();

    // Filtrar por query
    if (query.isEmpty) return filteredByCategory;

    return filteredByCategory
        .where((item) =>
            item['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['subtitle']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  // Métodos auxiliares para gerar dados realistas
  String _generateDocument() {
    final isCPF = _random.nextBool();
    if (isCPF) {
      return '${_random.nextInt(900) + 100}.${_random.nextInt(900) + 100}.${_random.nextInt(900) + 100}-${_random.nextInt(90) + 10}';
    } else {
      return '${_random.nextInt(90) + 10}.${_random.nextInt(900) + 100}.${_random.nextInt(900) + 100}/0001-${_random.nextInt(90) + 10}';
    }
  }

  String _generateEmail(String name) {
    final cleanName = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z\s]'), '')
        .replaceAll(' ', '');
    final domains = [
      'gmail.com',
      'outlook.com',
      'empresa.com.br',
      'comercio.com.br'
    ];
    return '$cleanName@${domains[_random.nextInt(domains.length)]}';
  }

  String _generatePhone() {
    return '(11) 9${_random.nextInt(9000) + 1000}-${_random.nextInt(9000) + 1000}';
  }

  String _generateAddress() {
    final streets = [
      'Rua das Flores',
      'Av. Paulista',
      'Rua Augusta',
      'Rua Oscar Freire',
      'Av. Faria Lima'
    ];
    final number = _random.nextInt(9000) + 100;
    return '${streets[_random.nextInt(streets.length)]}, $number - São Paulo/SP';
  }
}
