import 'package:flutter/material.dart';

class AdvancedFiltersPanel extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;

  const AdvancedFiltersPanel({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  State<AdvancedFiltersPanel> createState() => _AdvancedFiltersPanelState();
}

class _AdvancedFiltersPanelState extends State<AdvancedFiltersPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  // Filter states
  RangeValues _dateRange = const RangeValues(0, 12);
  final List<String> _selectedAreas = [];
  String _selectedStatus = 'Todos';
  double _minValue = 0;
  double _maxValue = 100000;

  final List<String> _areas = [
    'Trabalhista',
    'Penal',
    'Cível',
    'Cível Contencioso',
    'Tributário',
  ];

  final List<String> _statusOptions = [
    'Todos',
    'Ativos',
    'Finalizados',
    'Em Andamento',
    'Pendentes',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _updateFilters() {
    final filters = {
      'dateRange': _dateRange,
      'selectedAreas': _selectedAreas,
      'selectedStatus': _selectedStatus,
      'valueRange': {'min': _minValue, 'max': _maxValue},
    };
    widget.onFiltersChanged(filters);
  }

  void _resetFilters() {
    setState(() {
      _dateRange = const RangeValues(0, 12);
      _selectedAreas.clear();
      _selectedStatus = 'Todos';
      _minValue = 0;
      _maxValue = 100000;
    });
    _updateFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizeTransition(
            sizeFactor: _animation,
            child: _buildFiltersContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: _togglePanel,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF582FFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.tune,
                color: Color(0xFF582FFF),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtros Avançados',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Personalize sua análise',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeFilter(),
          const SizedBox(height: 20),
          _buildAreaSelector(),
          const SizedBox(height: 20),
          _buildStatusSelector(),
          const SizedBox(height: 20),
          _buildValueRangeFilter(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Período (meses)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _dateRange,
          min: 0,
          max: 12,
          divisions: 12,
          activeColor: const Color(0xFF582FFF),
          inactiveColor: const Color(0xFF582FFF).withOpacity(0.2),
          labels: RangeLabels(
            '${_dateRange.start.round()}m',
            '${_dateRange.end.round()}m',
          ),
          onChanged: (values) {
            setState(() {
              _dateRange = values;
            });
            _updateFilters();
          },
        ),
      ],
    );
  }

  Widget _buildAreaSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Áreas Jurídicas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _areas.map((area) {
            final isSelected = _selectedAreas.contains(area);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedAreas.remove(area);
                  } else {
                    _selectedAreas.add(area);
                  }
                });
                _updateFilters();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF582FFF)
                      : const Color(0xFF582FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF582FFF),
                    width: 1,
                  ),
                ),
                child: Text(
                  area,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF582FFF),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
                _updateFilters();
              },
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Faixa de Valor (R\$)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Mín',
                  border: OutlineInputBorder(),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _minValue = double.tryParse(value) ?? 0;
                  _updateFilters();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Máx',
                  border: OutlineInputBorder(),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _maxValue = double.tryParse(value) ?? 100000;
                  _updateFilters();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF582FFF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Limpar',
              style: TextStyle(color: Color(0xFF582FFF)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _updateFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtros aplicados com sucesso!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF582FFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Aplicar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
