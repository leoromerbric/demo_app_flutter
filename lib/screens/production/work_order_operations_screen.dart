import 'package:flutter/material.dart';
import '../../models/production_models.dart';
import '../../services/production_service.dart';
import 'operation_confirmation_screen.dart';

class WorkOrderOperationsScreen extends StatefulWidget {
  final WorkOrder workOrder;
  final VoidCallback onThemeToggle;

  const WorkOrderOperationsScreen({
    super.key,
    required this.workOrder,
    required this.onThemeToggle,
  });

  @override
  State<WorkOrderOperationsScreen> createState() => _WorkOrderOperationsScreenState();
}

class _WorkOrderOperationsScreenState extends State<WorkOrderOperationsScreen> {
  late List<Operation> _operations;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _operations = widget.workOrder.operations;
  }

  void _refreshOperations() {
    setState(() {
      _isLoading = true;
    });

    // Simular actualización de datos
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _operations = ProductionService.getOperationsForWorkOrder(widget.workOrder.id);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Operaciones - ${widget.workOrder.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOperations,
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
          _buildWorkOrderHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _operations.isEmpty
                    ? _buildEmptyState()
                    : _buildOperationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkOrderHeader() {
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
              Expanded(
                child: Text(
                  widget.workOrder.description,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.workOrder.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.workOrder.status.color,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.workOrder.status.displayName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: widget.workOrder.status.color,
                    fontWeight: FontWeight.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.receipt_long,
                  'Pedido/Pos',
                  '${widget.workOrder.customerOrder} / ${widget.workOrder.customerPosition}',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.factory,
                  'Centro',
                  widget.workOrder.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.precision_manufacturing,
                  'Puesto',
                  widget.workOrder.workStation,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.inventory_2,
                  'Material',
                  widget.workOrder.material,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progreso de Producción',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.medium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: widget.workOrder.plannedQuantity > 0
                                ? (widget.workOrder.confirmedQuantity / widget.workOrder.plannedQuantity).clamp(0.0, 1.0)
                                : 0.0,
                            backgroundColor: colorScheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.workOrder.confirmedQuantity >= widget.workOrder.plannedQuantity
                                  ? Colors.green
                                  : colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.workOrder.confirmedQuantity.toStringAsFixed(0)}/${widget.workOrder.plannedQuantity.toStringAsFixed(0)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.medium,
                          ),
                        ),
                      ],
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

  Widget _buildInfoItem(IconData icon, String label, String value) {
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
        Expanded(
          child: Column(
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.engineering,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay operaciones disponibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta orden de trabajo no tiene operaciones definidas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _operations.length,
      itemBuilder: (context, index) => _buildOperationCard(_operations[index]),
    );
  }

  Widget _buildOperationCard(Operation operation) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: operation.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    operation.operationNumber,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: operation.status.color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        operation.description,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.precision_manufacturing,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            operation.workStation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: operation.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: operation.status.color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    operation.status.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: operation.status.color,
                      fontWeight: FontWeight.medium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Información de cantidades
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cantidades',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.medium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: operation.plannedQuantity > 0
                                  ? (operation.confirmedQuantity / operation.plannedQuantity).clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: colorScheme.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                operation.confirmedQuantity >= operation.plannedQuantity
                                    ? Colors.green
                                    : colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${operation.confirmedQuantity.toStringAsFixed(0)}/${operation.plannedQuantity.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.medium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Información de fechas
            if (operation.startDate != null || operation.endDate != null) ...[
              Row(
                children: [
                  if (operation.startDate != null)
                    Expanded(
                      child: _buildDateInfo(
                        Icons.play_arrow,
                        'Inicio',
                        operation.startDate!,
                      ),
                    ),
                  if (operation.startDate != null && operation.endDate != null)
                    const SizedBox(width: 16),
                  if (operation.endDate != null)
                    Expanded(
                      child: _buildDateInfo(
                        Icons.stop,
                        'Fin',
                        operation.endDate!,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Información de actividades
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${operation.activities.length} actividad(es)',
                  style: theme.textTheme.bodySmall?.copyWith(
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
                  '${operation.components.length} componente(s)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Botón de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: operation.status != OperationStatus.confirmed
                    ? () => _navigateToConfirmation(operation)
                    : null,
                icon: Icon(
                  operation.status == OperationStatus.confirmed
                      ? Icons.check_circle
                      : Icons.play_arrow,
                ),
                label: Text(
                  operation.status == OperationStatus.confirmed
                      ? 'Operación Confirmada'
                      : 'Confirmar Operación',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: operation.status == OperationStatus.confirmed
                      ? Colors.green
                      : null,
                  foregroundColor: operation.status == OperationStatus.confirmed
                      ? Colors.white
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(IconData icon, String label, DateTime date) {
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
              '${date.day}/${date.month}/${date.year}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.medium,
              ),
            ),
            Text(
              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToConfirmation(Operation operation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OperationConfirmationScreen(
          workOrder: widget.workOrder,
          operation: operation,
          onThemeToggle: widget.onThemeToggle,
          onOperationUpdated: (updatedOperation) {
            setState(() {
              final index = _operations.indexWhere((op) => op.id == updatedOperation.id);
              if (index != -1) {
                _operations[index] = updatedOperation;
              }
            });
          },
        ),
      ),
    );
  }
}