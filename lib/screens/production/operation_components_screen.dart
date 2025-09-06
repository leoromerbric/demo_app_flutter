import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/production_models.dart';
import '../../services/production_service.dart';

class OperationComponentsScreen extends StatefulWidget {
  final WorkOrder workOrder;
  final Operation operation;
  final VoidCallback onThemeToggle;

  const OperationComponentsScreen({
    super.key,
    required this.workOrder,
    required this.operation,
    required this.onThemeToggle,
  });

  @override
  State<OperationComponentsScreen> createState() => _OperationComponentsScreenState();
}

class _OperationComponentsScreenState extends State<OperationComponentsScreen> {
  late List<MaterialComponent> _components;
  final _searchController = TextEditingController();
  bool _isLoading = false;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _components = widget.operation.components.map((comp) => comp.copyWith()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Componentes - ${widget.operation.operationNumber}'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                }
              });
            },
            tooltip: _showSearch ? 'Ocultar búsqueda' : 'Buscar componente',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddComponentDialog,
            tooltip: 'Agregar componente',
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
          _buildOperationHeader(),
          if (_showSearch) _buildSearchSection(),
          _buildComponentsSummary(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _components.isEmpty
                    ? _buildEmptyState()
                    : _buildComponentsList(),
          ),
          _buildBottomActions(),
        ],
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
          Text(
            widget.operation.description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.workOrder.id} - ${widget.workOrder.material}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Buscar material por código o descripción',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // En una implementación real, aquí se buscarían materiales
          // Por ahora, solo mantenemos la UI
        },
      ),
    );
  }

  Widget _buildComponentsSummary() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final totalComponents = _components.length;
    final consumedComponents = _components.where((c) => c.isConsumed).length;
    final pendingComponents = totalComponents - consumedComponents;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              'Total',
              totalComponents.toString(),
              Icons.inventory_2,
              colorScheme.primary,
            ),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Consumidos',
              consumedComponents.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Pendientes',
              pendingComponents.toString(),
              Icons.pending,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
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
            Icons.inventory_2,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay componentes definidos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega componentes para gestionar el consumo de materiales',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showAddComponentDialog,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Componente'),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _components.length,
      itemBuilder: (context, index) => _buildComponentCard(_components[index], index),
    );
  }

  Widget _buildComponentCard(MaterialComponent component, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    color: component.movementType == MaterialMovementType.consumption
                        ? Colors.blue.withOpacity(0.1)
                        : component.movementType == MaterialMovementType.return
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    component.movementType.icon,
                    color: component.movementType == MaterialMovementType.consumption
                        ? Colors.blue
                        : component.movementType == MaterialMovementType.return
                            ? Colors.orange
                            : Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        component.materialCode,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        component.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showComponentOptions(component, index),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Información de cantidades
            Row(
              children: [
                Expanded(
                  child: _buildQuantityField(
                    'Cantidad Real',
                    component.actualQuantity,
                    component.unitOfMeasure,
                    (value) => _updateComponentQuantity(index, value),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Planificado',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${component.plannedQuantity.toStringAsFixed(1)} ${component.unitOfMeasure}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información adicional
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    Icons.warehouse,
                    'Almacén',
                    component.warehouse,
                  ),
                ),
                const SizedBox(width: 8),
                if (component.batch != null)
                  Expanded(
                    child: _buildInfoChip(
                      Icons.inventory,
                      'Lote',
                      component.batch!,
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    Icons.category,
                    'Tipo',
                    component.movementType.displayName,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Estado y acciones
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: component.isConsumed 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    component.isConsumed ? 'Consumido' : 'Pendiente',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: component.isConsumed ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.medium,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _toggleConsumption(index),
                  icon: Icon(
                    component.isConsumed ? Icons.undo : Icons.check,
                    size: 16,
                  ),
                  label: Text(
                    component.isConsumed ? 'Desmarcar' : 'Marcar consumido',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityField(
    String label,
    double value,
    String unit,
    Function(double) onChanged,
  ) {
    final controller = TextEditingController(text: value.toString());
    
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: (text) {
        final quantity = double.tryParse(text) ?? value;
        onChanged(quantity);
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.medium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _validateStock,
              icon: const Icon(Icons.inventory_2),
              label: const Text('Validar Stock'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Guardar Cambios'),
            ),
          ),
        ],
      ),
    );
  }

  void _updateComponentQuantity(int index, double quantity) {
    setState(() {
      _components[index] = _components[index].copyWith(actualQuantity: quantity);
    });
  }

  void _toggleConsumption(int index) {
    setState(() {
      _components[index] = _components[index].copyWith(
        isConsumed: !_components[index].isConsumed,
      );
    });
  }

  void _showComponentOptions(MaterialComponent component, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar componente'),
            onTap: () {
              Navigator.pop(context);
              _showEditComponentDialog(component, index);
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('Escanear código de barras'),
            onTap: () {
              Navigator.pop(context);
              _scanBarcode(index);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar componente'),
            onTap: () {
              Navigator.pop(context);
              _removeComponent(index);
            },
          ),
        ],
      ),
    );
  }

  void _showAddComponentDialog() {
    showDialog(
      context: context,
      builder: (context) => _ComponentDialog(
        title: 'Agregar Componente',
        onSave: (component) {
          setState(() {
            _components.add(component);
          });
        },
      ),
    );
  }

  void _showEditComponentDialog(MaterialComponent component, int index) {
    showDialog(
      context: context,
      builder: (context) => _ComponentDialog(
        title: 'Editar Componente',
        component: component,
        onSave: (updatedComponent) {
          setState(() {
            _components[index] = updatedComponent;
          });
        },
      ),
    );
  }

  void _scanBarcode(int index) {
    // Simular escaneo de código de barras
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de escaneo de código de barras simulada'),
      ),
    );
  }

  void _removeComponent(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Componente'),
        content: Text('¿Está seguro de eliminar el componente ${_components[index].materialCode}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _components.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _validateStock() {
    setState(() {
      _isLoading = true;
    });

    // Simular validación de stock
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validación de stock completada - Stock suficiente'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambios guardados exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _ComponentDialog extends StatefulWidget {
  final String title;
  final MaterialComponent? component;
  final Function(MaterialComponent) onSave;

  const _ComponentDialog({
    required this.title,
    this.component,
    required this.onSave,
  });

  @override
  State<_ComponentDialog> createState() => _ComponentDialogState();
}

class _ComponentDialogState extends State<_ComponentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _plannedQuantityController = TextEditingController();
  final _actualQuantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _batchController = TextEditingController();
  
  MaterialMovementType _movementType = MaterialMovementType.consumption;
  String _valuationClass = 'RAW';

  @override
  void initState() {
    super.initState();
    
    if (widget.component != null) {
      final component = widget.component!;
      _codeController.text = component.materialCode;
      _descriptionController.text = component.description;
      _plannedQuantityController.text = component.plannedQuantity.toString();
      _actualQuantityController.text = component.actualQuantity.toString();
      _unitController.text = component.unitOfMeasure;
      _warehouseController.text = component.warehouse;
      _batchController.text = component.batch ?? '';
      _movementType = component.movementType;
      _valuationClass = component.valuationClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Código Material *',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción *',
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _plannedQuantityController,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad Planificada *',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Campo requerido';
                          if (double.tryParse(value!) == null) return 'Número inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _unitController,
                        decoration: const InputDecoration(
                          labelText: 'Unidad *',
                          hintText: 'KG, UN, L, etc.',
                        ),
                        validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _warehouseController,
                  decoration: const InputDecoration(
                    labelText: 'Almacén *',
                    prefixIcon: Icon(Icons.warehouse),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _batchController,
                  decoration: const InputDecoration(
                    labelText: 'Lote',
                    prefixIcon: Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<MaterialMovementType>(
                  value: _movementType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Movimiento *',
                    prefixIcon: Icon(Icons.swap_horiz),
                  ),
                  items: MaterialMovementType.values.map((type) => 
                    DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _movementType = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveComponent,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  void _saveComponent() {
    if (!_formKey.currentState!.validate()) return;

    final component = MaterialComponent(
      id: widget.component?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      operationId: widget.component?.operationId ?? '',
      materialCode: _codeController.text,
      description: _descriptionController.text,
      plannedQuantity: double.parse(_plannedQuantityController.text),
      actualQuantity: double.tryParse(_actualQuantityController.text) ?? 0.0,
      unitOfMeasure: _unitController.text,
      warehouse: _warehouseController.text,
      batch: _batchController.text.isNotEmpty ? _batchController.text : null,
      valuationClass: _valuationClass,
      movementType: _movementType,
      isConsumed: widget.component?.isConsumed ?? false,
    );

    widget.onSave(component);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _plannedQuantityController.dispose();
    _actualQuantityController.dispose();
    _unitController.dispose();
    _warehouseController.dispose();
    _batchController.dispose();
    super.dispose();
  }
}