import 'package:flutter/material.dart';
import '../../models/production_models.dart';
import '../../services/production_service.dart';
import 'work_order_operations_screen.dart';

class WorkOrderListScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const WorkOrderListScreen({super.key, required this.onThemeToggle});

  @override
  State<WorkOrderListScreen> createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  final _customerOrderController = TextEditingController();
  final _customerPositionController = TextEditingController();
  final _centerController = TextEditingController();
  final _workStationController = TextEditingController();
  
  WorkOrderFilter _filter = const WorkOrderFilter();
  List<WorkOrder> _workOrders = [];
  bool _isLoading = true;
  bool _showFilters = false;
  DateTime? _startDate;
  DateTime? _endDate;
  WorkOrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadWorkOrders();
  }

  void _loadWorkOrders() {
    setState(() {
      _isLoading = true;
    });

    // Simular carga de datos
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _workOrders = _filter.hasFilters 
              ? ProductionService.filterWorkOrders(_filter)
              : ProductionService.getAllWorkOrders();
          _isLoading = false;
        });
      }
    });
  }

  void _applyFilters() {
    _filter = WorkOrderFilter(
      customerOrder: _customerOrderController.text.isNotEmpty 
          ? _customerOrderController.text 
          : null,
      customerPosition: _customerPositionController.text.isNotEmpty 
          ? _customerPositionController.text 
          : null,
      center: _centerController.text.isNotEmpty 
          ? _centerController.text 
          : null,
      workStation: _workStationController.text.isNotEmpty 
          ? _workStationController.text 
          : null,
      startDate: _startDate,
      endDate: _endDate,
      status: _selectedStatus,
    );
    
    _loadWorkOrders();
    setState(() {
      _showFilters = false;
    });
  }

  void _clearFilters() {
    _customerOrderController.clear();
    _customerPositionController.clear();
    _centerController.clear();
    _workStationController.clear();
    _startDate = null;
    _endDate = null;
    _selectedStatus = null;
    
    _filter = const WorkOrderFilter();
    _loadWorkOrders();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isStartDate ? 'Seleccionar fecha inicio' : 'Seleccionar fecha fin',
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Trabajo'),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              semanticLabel: _showFilters ? 'Ocultar filtros' : 'Mostrar filtros',
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: _showFilters ? 'Ocultar filtros' : 'Mostrar filtros',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWorkOrders,
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Cambiar tema',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilterSection(),
          if (_filter.hasFilters) _buildActiveFiltersChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _workOrders.isEmpty
                    ? _buildEmptyState()
                    : _buildWorkOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _customerOrderController,
                  decoration: const InputDecoration(
                    labelText: 'Pedido Cliente',
                    hintText: 'Ej: PED-2024-001',
                    prefixIcon: Icon(Icons.receipt_long),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _customerPositionController,
                  decoration: const InputDecoration(
                    labelText: 'Posición',
                    hintText: 'Ej: 10',
                    prefixIcon: Icon(Icons.numbers),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _centerController.text.isNotEmpty ? _centerController.text : null,
                  decoration: const InputDecoration(
                    labelText: 'Centro/Planta',
                    prefixIcon: Icon(Icons.factory),
                    isDense: true,
                  ),
                  items: ProductionService.getAvailableCenters()
                      .map((center) => DropdownMenuItem(
                            value: center,
                            child: Text(center),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _centerController.text = value ?? '';
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _workStationController.text.isNotEmpty ? _workStationController.text : null,
                  decoration: const InputDecoration(
                    labelText: 'Puesto de Trabajo',
                    prefixIcon: Icon(Icons.precision_manufacturing),
                    isDense: true,
                  ),
                  items: ProductionService.getAvailableWorkStations()
                      .map((station) => DropdownMenuItem(
                            value: station,
                            child: Text(station),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _workStationController.text = value ?? '';
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha Inicio',
                      prefixIcon: Icon(Icons.calendar_today),
                      isDense: true,
                    ),
                    child: Text(
                      _startDate != null
                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: _startDate != null
                            ? null
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha Fin',
                      prefixIcon: Icon(Icons.event),
                      isDense: true,
                    ),
                    child: Text(
                      _endDate != null
                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: _endDate != null
                            ? null
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<WorkOrderStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Estado',
              prefixIcon: Icon(Icons.info),
              isDense: true,
            ),
            items: WorkOrderStatus.values
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.displayName),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _applyFilters,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    final chips = <Widget>[];
    
    if (_filter.customerOrder != null) {
      chips.add(Chip(
        label: Text('Pedido: ${_filter.customerOrder}'),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          _customerOrderController.clear();
          _applyFilters();
        },
      ));
    }
    
    if (_filter.center != null) {
      chips.add(Chip(
        label: Text('Centro: ${_filter.center}'),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          _centerController.clear();
          _applyFilters();
        },
      ));
    }
    
    if (_filter.status != null) {
      chips.add(Chip(
        label: Text('Estado: ${_filter.status!.displayName}'),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          setState(() {
            _selectedStatus = null;
          });
          _applyFilters();
        },
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: chips,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron órdenes de trabajo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _filter.hasFilters
                ? 'Intenta modificar los filtros de búsqueda'
                : 'No hay órdenes de trabajo disponibles',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          if (_filter.hasFilters) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar filtros'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _workOrders.length,
      itemBuilder: (context, index) => _buildWorkOrderCard(_workOrders[index]),
    );
  }

  Widget _buildWorkOrderCard(WorkOrder workOrder) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToOperations(workOrder),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      workOrder.id,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: workOrder.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: workOrder.status.color,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      workOrder.status.displayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: workOrder.status.color,
                        fontWeight: FontWeight.medium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                workOrder.description,
                style: theme.textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${workOrder.customerOrder} / ${workOrder.customerPosition}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.factory,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    workOrder.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.precision_manufacturing,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    workOrder.workStation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.inventory_2,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${workOrder.confirmedQuantity.toStringAsFixed(0)}/${workOrder.plannedQuantity.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.medium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: workOrder.plannedQuantity > 0
                    ? (workOrder.confirmedQuantity / workOrder.plannedQuantity).clamp(0.0, 1.0)
                    : 0.0,
                backgroundColor: colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  workOrder.confirmedQuantity >= workOrder.plannedQuantity
                      ? Colors.green
                      : colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.engineering,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${workOrder.operations.length} operación(es)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToOperations(WorkOrder workOrder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkOrderOperationsScreen(
          workOrder: workOrder,
          onThemeToggle: widget.onThemeToggle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerOrderController.dispose();
    _customerPositionController.dispose();
    _centerController.dispose();
    _workStationController.dispose();
    super.dispose();
  }
}