import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../shared/services/mock_data_service.dart';
import '../../shared/models/client.dart';
import '../../shared/models/user.dart';
import '../models/folder.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mockService = MockDataService();
  
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contractValueController = TextEditingController();
  final _processNumberController = TextEditingController();
  final _courtNumberController = TextEditingController();
  
  // Form data
  Client? _selectedClient;
  User? _selectedLawyer;
  List<User> _selectedAssistants = [];
  FolderArea _selectedArea = FolderArea.civilLitigation;
  FolderPriority _selectedPriority = FolderPriority.medium;
  DateTime? _dueDate;
  
  // Lists
  late List<Client> _clients;
  late List<User> _lawyers;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() {
    _clients = _mockService.getClients();
    _lawyers = _mockService.getUsers();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contractValueController.dispose();
    _processNumberController.dispose();
    _courtNumberController.dispose();
    super.dispose();
  }
  
  void _createFolder() {
    if (_formKey.currentState!.validate() && _selectedClient != null && _selectedLawyer != null) {
      final newFolder = _mockService.createFolder({
        'title': _titleController.text,
        'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        'area': _selectedArea,
        'priority': _selectedPriority,
        'client': _selectedClient,
        'responsibleLawyer': _selectedLawyer,
        'assistantLawyers': _selectedAssistants.isNotEmpty ? _selectedAssistants : null,
        'dueDate': _dueDate,
        'contractValue': _contractValueController.text.isNotEmpty 
            ? double.tryParse(_contractValueController.text.replaceAll(',', '.'))
            : null,
        'processNumber': _processNumberController.text.isNotEmpty ? _processNumberController.text : null,
        'courtNumber': _courtNumberController.text.isNotEmpty ? _courtNumberController.text : null,
      });
      
      Navigator.pop(context, newFolder);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pasta "${newFolder.title}" criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Criar Novo Processo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: themeProvider.themeData.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cada pasta representa um processo do cliente',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProvider.themeData.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client selection - FIRST AND PROMINENT
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeProvider.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: themeProvider.primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: themeProvider.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Cliente do Processo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<Client>(
                              value: _selectedClient,
                              decoration: const InputDecoration(
                                labelText: 'Selecione o cliente *',
                                hintText: 'Para qual cliente é este processo?',
                                prefixIcon: Icon(Icons.search),
                              ),
                        items: _clients.map((client) {
                          return DropdownMenuItem(
                            value: client,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: client.type == ClientType.corporate
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    client.type == ClientType.corporate ? 'PJ' : 'PF',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: client.type == ClientType.corporate
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    client.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedClient = value),
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um cliente';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Area and Priority
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<FolderArea>(
                              value: _selectedArea,
                              decoration: const InputDecoration(
                                labelText: 'Área',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: FolderArea.values.map((area) {
                                return DropdownMenuItem(
                                  value: area,
                                  child: Text(area.displayName),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedArea = value!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<FolderPriority>(
                              value: _selectedPriority,
                              decoration: const InputDecoration(
                                labelText: 'Prioridade',
                                prefixIcon: Icon(Icons.flag_outlined),
                              ),
                              items: FolderPriority.values.map((priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(priority),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(_getPriorityLabel(priority)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedPriority = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Responsible lawyer
                      DropdownButtonFormField<User>(
                        value: _selectedLawyer,
                        decoration: const InputDecoration(
                          labelText: 'Advogado Responsável *',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                        items: _lawyers.map((lawyer) {
                          return DropdownMenuItem(
                            value: lawyer,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: themeProvider.primaryColor.withOpacity(0.1),
                                  child: Text(
                                    lawyer.initials,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: themeProvider.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(lawyer.name, style: const TextStyle(fontSize: 14)),
                                      Text(
                                        lawyer.role,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: themeProvider.themeData.textTheme.bodySmall?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedLawyer = value),
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um advogado responsável';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Assistant lawyers (multi-select)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.group_outlined, size: 20),
                                const SizedBox(width: 8),
                                const Text('Advogados Assistentes (opcional)'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _lawyers
                                  .where((l) => l != _selectedLawyer)
                                  .map((lawyer) {
                                return FilterChip(
                                  label: Text(lawyer.name),
                                  selected: _selectedAssistants.contains(lawyer),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedAssistants.add(lawyer);
                                      } else {
                                        _selectedAssistants.remove(lawyer);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição (opcional)',
                          hintText: 'Adicione detalhes sobre o processo...',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      
                      // Process and Court numbers
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _processNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Número do Processo',
                                hintText: '0000000-00.0000.0.00.0000',
                                prefixIcon: Icon(Icons.numbers),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _courtNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Vara/Tribunal',
                                hintText: 'Ex: 2ª Vara Cível',
                                prefixIcon: Icon(Icons.gavel),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Contract value and Due date
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contractValueController,
                              decoration: const InputDecoration(
                                labelText: 'Valor do Contrato',
                                hintText: '0,00',
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(const Duration(days: 30)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _dueDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Prazo',
                                  prefixIcon: Icon(Icons.calendar_today_outlined),
                                ),
                                child: Text(
                                  _dueDate != null
                                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                                      : 'Selecionar data',
                                  style: TextStyle(
                                    color: _dueDate != null
                                        ? null
                                        : themeProvider.themeData.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _createFolder,
                    icon: const Icon(Icons.add),
                    label: const Text('Criar Pasta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getPriorityColor(FolderPriority priority) {
    switch (priority) {
      case FolderPriority.low:
        return Colors.green;
      case FolderPriority.medium:
        return Colors.orange;
      case FolderPriority.high:
        return Colors.deepOrange;
      case FolderPriority.urgent:
        return Colors.red;
    }
  }
  
  String _getPriorityLabel(FolderPriority priority) {
    switch (priority) {
      case FolderPriority.low:
        return 'Baixa';
      case FolderPriority.medium:
        return 'Média';
      case FolderPriority.high:
        return 'Alta';
      case FolderPriority.urgent:
        return 'Urgente';
    }
  }
}
