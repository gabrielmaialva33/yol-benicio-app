import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../services/mock_data_service.dart';
import '../models/client.dart';

class CreateClientDialog extends StatefulWidget {
  const CreateClientDialog({super.key});

  @override
  State<CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends State<CreateClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mockService = MockDataService();
  
  // Controllers
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Form data
  ClientType _selectedType = ClientType.individual;
  ClientStatus _selectedStatus = ClientStatus.active;
  String _preferredContact = 'email';
  
  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  void _createClient() {
    if (_formKey.currentState!.validate()) {
      // Create client through mock service
      final newClient = Client(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        document: _documentController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        type: _selectedType,
        status: _selectedStatus,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        clientSince: DateTime.now(),
        activeFolders: 0,
        totalBilled: 0,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        preferredContact: _preferredContact,
      );
      
      // Save to mock service
      final savedClient = _mockService.createClient(newClient);
      
      Navigator.pop(context, savedClient);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cliente "${savedClient.name}" criado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  String? _validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'Documento é obrigatório';
    }
    
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (_selectedType == ClientType.individual) {
      if (cleanValue.length != 11) {
        return 'CPF deve ter 11 dígitos';
      }
    } else {
      if (cleanValue.length != 14) {
        return 'CNPJ deve ter 14 dígitos';
      }
    }
    
    return null;
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
                  Text(
                    'Criar Novo Cliente',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: themeProvider.themeData.textTheme.titleLarge?.color,
                    ),
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
                      // Client type selection
                      const Text(
                        'Tipo de Cliente',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<ClientType>(
                              title: const Text('Pessoa Física'),
                              value: ClientType.individual,
                              groupValue: _selectedType,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _documentController.clear();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<ClientType>(
                              title: const Text('Pessoa Jurídica'),
                              value: ClientType.corporate,
                              groupValue: _selectedType,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _documentController.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: _selectedType == ClientType.individual 
                              ? 'Nome Completo *' 
                              : 'Razão Social *',
                          hintText: _selectedType == ClientType.individual
                              ? 'Ex: João Silva'
                              : 'Ex: Empresa XYZ Ltda',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedType == ClientType.individual
                                ? 'Nome é obrigatório'
                                : 'Razão Social é obrigatória';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Document field
                      TextFormField(
                        controller: _documentController,
                        decoration: InputDecoration(
                          labelText: _selectedType == ClientType.individual ? 'CPF *' : 'CNPJ *',
                          hintText: _selectedType == ClientType.individual
                              ? '000.000.000-00'
                              : '00.000.000/0000-00',
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _selectedType == ClientType.individual
                              ? _CpfInputFormatter()
                              : _CnpjInputFormatter(),
                        ],
                        validator: _validateDocument,
                      ),
                      const SizedBox(height: 16),
                      
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail *',
                          hintText: 'cliente@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-mail é obrigatório';
                          }
                          if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Phone field
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone *',
                          hintText: '(00) 00000-0000',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _PhoneInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Telefone é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Address field
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Endereço',
                          hintText: 'Rua, número, bairro, cidade - UF',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      
                      // Preferred contact
                      DropdownButtonFormField<String>(
                        value: _preferredContact,
                        decoration: const InputDecoration(
                          labelText: 'Contato Preferencial',
                          prefixIcon: Icon(Icons.contact_phone_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'email', child: Text('E-mail')),
                          DropdownMenuItem(value: 'phone', child: Text('Telefone')),
                          DropdownMenuItem(value: 'whatsapp', child: Text('WhatsApp')),
                        ],
                        onChanged: (value) => setState(() => _preferredContact = value!),
                      ),
                      const SizedBox(height: 16),
                      
                      // Status
                      DropdownButtonFormField<ClientStatus>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.toggle_on_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: ClientStatus.active,
                            child: Text('Ativo'),
                          ),
                          DropdownMenuItem(
                            value: ClientStatus.inactive,
                            child: Text('Inativo'),
                          ),
                          DropdownMenuItem(
                            value: ClientStatus.vip,
                            child: Row(
                              children: [
                                Text('VIP'),
                                SizedBox(width: 8),
                                Icon(Icons.star, size: 16, color: Colors.amber),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                      ),
                      const SizedBox(height: 16),
                      
                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                          hintText: 'Informações adicionais sobre o cliente...',
                          prefixIcon: Icon(Icons.note_outlined),
                        ),
                        maxLines: 3,
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
                    onPressed: _createClient,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Criar Cliente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CPF formatter
class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < newText.length && i < 11; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(newText[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// CNPJ formatter
class _CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < newText.length && i < 14; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(newText[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Phone formatter
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < newText.length && i < 11; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 7) buffer.write('-');
      buffer.write(newText[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
