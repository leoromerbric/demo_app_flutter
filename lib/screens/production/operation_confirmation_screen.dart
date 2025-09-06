import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/production_models.dart';
import '../../services/production_service.dart';
import 'operation_components_screen.dart';

class OperationConfirmationScreen extends StatefulWidget {
  final WorkOrder workOrder;
  final Operation operation;
  final VoidCallback onThemeToggle;
  final Function(Operation) onOperationUpdated;

  const OperationConfirmationScreen({
    super.key,
    required this.workOrder,
    required this.operation,
    required this.onThemeToggle,
    required this.onOperationUpdated,
  });

  @override
  State<OperationConfirmationScreen> createState() => _OperationConfirmationScreenState();
}

class _OperationConfirmationScreenState extends State<OperationConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goodQuantityController = TextEditingController();
  final _rejectQuantityController = TextEditingController();
  final _reworkQuantityController = TextEditingController();
  
  late List<Activity> _activities;
  bool _compensateReserves = false;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _activities = widget.operation.activities.map((activity) => activity.copyWith()).toList();
    
    // Valores por defecto basados en cantidades pendientes
    final pendingQuantity = widget.operation.plannedQuantity - widget.operation.confirmedQuantity;
    _goodQuantityController.text = pendingQuantity > 0 ? pendingQuantity.toStringAsFixed(0) : '0';
    _rejectQuantityController.text = '0';
    _reworkQuantityController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar - ${widget.operation.operationNumber}'),
        actions: [
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildOperationHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuantitiesSection(),
                    const SizedBox(height: 24),
                    _buildActivitiesSection(),
                    const SizedBox(height: 24),
                    _buildOptionsSection(),
                    const SizedBox(height: 24),
                    _buildActionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.operation.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.operation.operationNumber,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.operation.status.color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.operation.description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.workOrder.id} - ${widget.workOrder.material}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHeaderInfo(
                  Icons.factory,
                  'Centro',
                  widget.workOrder.center,
                ),
              ),
              Expanded(
                child: _buildHeaderInfo(
                  Icons.precision_manufacturing,
                  'Puesto',
                  widget.operation.workStation,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.medium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitiesSection() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cantidades',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _goodQuantityController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad Buena',
                      prefixIcon: Icon(Icons.check_circle, color: Colors.green),
                      suffixText: 'UN',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la cantidad buena';
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null || quantity < 0) {
                        return 'Ingrese una cantidad válida';
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _rejectQuantityController,
                    decoration: const InputDecoration(
                      labelText: 'Rechazo',
                      prefixIcon: Icon(Icons.cancel, color: Colors.red),
                      suffixText: 'UN',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final quantity = double.tryParse(value);
                        if (quantity == null || quantity < 0) {
                          return 'Cantidad inválida';
                        }
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _reworkQuantityController,
                    decoration: const InputDecoration(
                      labelText: 'Reproceso',
                      prefixIcon: Icon(Icons.refresh, color: Colors.orange),
                      suffixText: 'UN',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final quantity = double.tryParse(value);
                        if (quantity == null || quantity < 0) {
                          return 'Cantidad inválida';
                        }
                      }
                      return null;
                    },
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Confirmado',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getTotalConfirmed().toStringAsFixed(0)} UN',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Actividades',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: \$${_getTotalActivityCost().toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              return _buildActivityItem(activity, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Activity activity, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activity.type.shortName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  activity.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.medium,
                  ),
                ),
              ),
              Text(
                '\$${activity.calculatedCost.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: activity.actualTime.toString(),
                  decoration: InputDecoration(
                    labelText: 'Tiempo Real (hrs)',
                    isDense: true,
                    border: const OutlineInputBorder(),
                    hintText: activity.plannedTime.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: (value) {
                    final time = double.tryParse(value) ?? activity.actualTime;
                    setState(() {
                      _activities[index] = activity.copyWith(
                        actualTime: time,
                        totalCost: time * activity.rate,
                      );
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'Tarifa',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '\$${activity.rate.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opciones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Compensar reservas abiertas'),
              subtitle: const Text('Ajustar automáticamente las reservas de material'),
              value: _compensateReserves,
              onChanged: (value) {
                setState(() {
                  _compensateReserves = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _navigateToComponents(),
            icon: const Icon(Icons.inventory_2),
            label: const Text('Gestionar Componentes'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _confirmOperation,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle),
            label: const Text('Revisar y Confirmar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  double _getTotalConfirmed() {
    final good = double.tryParse(_goodQuantityController.text) ?? 0.0;
    final reject = double.tryParse(_rejectQuantityController.text) ?? 0.0;
    final rework = double.tryParse(_reworkQuantityController.text) ?? 0.0;
    return good + reject + rework;
  }

  double _getTotalActivityCost() {
    return _activities.fold(0.0, (sum, activity) => sum + activity.calculatedCost);
  }

  void _calculateTotals() {
    setState(() {
      // Los totales se calculan automáticamente en los métodos correspondientes
    });
  }

  void _navigateToComponents() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OperationComponentsScreen(
          workOrder: widget.workOrder,
          operation: widget.operation,
          onThemeToggle: widget.onThemeToggle,
        ),
      ),
    );
  }

  void _confirmOperation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final goodQuantity = double.tryParse(_goodQuantityController.text) ?? 0.0;
    final rejectQuantity = double.tryParse(_rejectQuantityController.text) ?? 0.0;
    final reworkQuantity = double.tryParse(_reworkQuantityController.text) ?? 0.0;

    if (goodQuantity + rejectQuantity + reworkQuantity == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe ingresar al menos una cantidad para confirmar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Mostrar resumen antes de confirmar
    final confirm = await _showConfirmationDialog(
      goodQuantity,
      rejectQuantity,
      reworkQuantity,
    );

    if (!confirm) return;

    setState(() {
      _isLoading = true;
    });

    // Simular confirmación
    await Future.delayed(const Duration(milliseconds: 1000));

    final success = ProductionService.confirmOperation(
      widget.operation.id,
      goodQuantity,
      rejectQuantity,
      reworkQuantity,
      _activities,
      widget.operation.components,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operación confirmada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Notificar la actualización
      final updatedOperation = widget.operation.copyWith(
        confirmedQuantity: _getTotalConfirmed(),
        status: OperationStatus.confirmed,
        endDate: DateTime.now(),
        activities: _activities,
      );
      
      widget.onOperationUpdated(updatedOperation);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al confirmar la operación'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _showConfirmationDialog(
    double goodQuantity,
    double rejectQuantity,
    double reworkQuantity,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Operación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Confirmar la operación con los siguientes datos?'),
            const SizedBox(height: 16),
            Text('• Cantidad Buena: ${goodQuantity.toStringAsFixed(0)} UN'),
            if (rejectQuantity > 0)
              Text('• Rechazo: ${rejectQuantity.toStringAsFixed(0)} UN'),
            if (reworkQuantity > 0)
              Text('• Reproceso: ${reworkQuantity.toStringAsFixed(0)} UN'),
            const SizedBox(height: 8),
            Text('• Total Confirmado: ${_getTotalConfirmed().toStringAsFixed(0)} UN'),
            Text('• Costo Total Actividades: \$${_getTotalActivityCost().toStringAsFixed(2)}'),
            if (_compensateReserves)
              const Text('• Se compensarán las reservas abiertas'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void dispose() {
    _goodQuantityController.dispose();
    _rejectQuantityController.dispose();
    _reworkQuantityController.dispose();
    super.dispose();
  }
}