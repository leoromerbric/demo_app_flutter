import '../models/production_models.dart';

/// Servicio para gestión de datos de producción
/// Simula una API con datos mock para demostración
class ProductionService {
  static final List<WorkOrder> _workOrders = [
    WorkOrder(
      id: 'WO001',
      customerOrder: 'PED-2024-001',
      customerPosition: '10',
      center: 'PLANTA01',
      workStation: 'WS001',
      material: 'MAT001',
      description: 'Producto A - Lote Especial',
      plannedQuantity: 100.0,
      confirmedQuantity: 75.0,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      status: WorkOrderStatus.started,
      operations: [
        Operation(
          id: 'OP001',
          workOrderId: 'WO001',
          operationNumber: '0010',
          description: 'Preparación de Materiales',
          workStation: 'WS001',
          plannedQuantity: 100.0,
          confirmedQuantity: 100.0,
          startDate: DateTime.now().subtract(const Duration(days: 2)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          status: OperationStatus.finished,
          activities: [
            Activity(
              id: 'ACT001',
              operationId: 'OP001',
              type: ActivityType.directLabor,
              code: 'MOD001',
              description: 'Mano de obra preparación',
              plannedTime: 2.0,
              actualTime: 2.5,
              rate: 25.0,
            ),
            Activity(
              id: 'ACT002',
              operationId: 'OP001',
              type: ActivityType.energy,
              code: 'ENE001',
              description: 'Consumo energético',
              plannedTime: 1.0,
              actualTime: 1.2,
              rate: 15.0,
            ),
          ],
          components: [
            MaterialComponent(
              id: 'COMP001',
              operationId: 'OP001',
              materialCode: 'MAT-RAW-001',
              description: 'Materia Prima A',
              plannedQuantity: 50.0,
              actualQuantity: 52.0,
              unitOfMeasure: 'KG',
              warehouse: 'ALM001',
              batch: 'LOTE-2024-001',
              valuationClass: 'RAW',
              movementType: MaterialMovementType.consumption,
              isConsumed: true,
            ),
            MaterialComponent(
              id: 'COMP002',
              operationId: 'OP001',
              materialCode: 'MAT-RAW-002',
              description: 'Materia Prima B',
              plannedQuantity: 25.0,
              actualQuantity: 23.0,
              unitOfMeasure: 'UN',
              warehouse: 'ALM001',
              batch: 'LOTE-2024-002',
              valuationClass: 'RAW',
              movementType: MaterialMovementType.consumption,
              isConsumed: true,
            ),
          ],
        ),
        Operation(
          id: 'OP002',
          workOrderId: 'WO001',
          operationNumber: '0020',
          description: 'Proceso Principal',
          workStation: 'WS002',
          plannedQuantity: 100.0,
          confirmedQuantity: 75.0,
          startDate: DateTime.now().subtract(const Duration(days: 1)),
          status: OperationStatus.started,
          activities: [
            Activity(
              id: 'ACT003',
              operationId: 'OP002',
              type: ActivityType.directLabor,
              code: 'MOD002',
              description: 'Mano de obra proceso',
              plannedTime: 4.0,
              actualTime: 3.5,
              rate: 30.0,
            ),
            Activity(
              id: 'ACT004',
              operationId: 'OP002',
              type: ActivityType.indirectLabor,
              code: 'IND001',
              description: 'Supervisión',
              plannedTime: 1.0,
              actualTime: 1.0,
              rate: 40.0,
            ),
            Activity(
              id: 'ACT005',
              operationId: 'OP002',
              type: ActivityType.depreciation,
              code: 'DEP001',
              description: 'Depreciación maquinaria',
              plannedTime: 4.0,
              actualTime: 3.5,
              rate: 12.0,
            ),
          ],
          components: [
            MaterialComponent(
              id: 'COMP003',
              operationId: 'OP002',
              materialCode: 'MAT-CHEM-001',
              description: 'Químico de Proceso',
              plannedQuantity: 10.0,
              actualQuantity: 9.5,
              unitOfMeasure: 'L',
              warehouse: 'ALM002',
              batch: 'LOTE-CHEM-001',
              valuationClass: 'CHEM',
              movementType: MaterialMovementType.consumption,
              isConsumed: false,
            ),
          ],
        ),
        Operation(
          id: 'OP003',
          workOrderId: 'WO001',
          operationNumber: '0030',
          description: 'Control de Calidad',
          workStation: 'WS003',
          plannedQuantity: 100.0,
          status: OperationStatus.created,
          activities: [
            Activity(
              id: 'ACT006',
              operationId: 'OP003',
              type: ActivityType.directLabor,
              code: 'MOD003',
              description: 'Inspección de calidad',
              plannedTime: 1.5,
              rate: 35.0,
            ),
          ],
          components: [],
        ),
      ],
    ),
    WorkOrder(
      id: 'WO002',
      customerOrder: 'PED-2024-002',
      customerPosition: '20',
      center: 'PLANTA01',
      workStation: 'WS004',
      material: 'MAT002',
      description: 'Producto B - Producción Estándar',
      plannedQuantity: 200.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
      status: WorkOrderStatus.released,
      operations: [
        Operation(
          id: 'OP004',
          workOrderId: 'WO002',
          operationNumber: '0010',
          description: 'Montaje Base',
          workStation: 'WS004',
          plannedQuantity: 200.0,
          status: OperationStatus.released,
          activities: [
            Activity(
              id: 'ACT007',
              operationId: 'OP004',
              type: ActivityType.directLabor,
              code: 'MOD004',
              description: 'Mano de obra montaje',
              plannedTime: 6.0,
              rate: 28.0,
            ),
            Activity(
              id: 'ACT008',
              operationId: 'OP004',
              type: ActivityType.energy,
              code: 'ENE002',
              description: 'Consumo energético montaje',
              plannedTime: 2.0,
              rate: 18.0,
            ),
          ],
          components: [
            MaterialComponent(
              id: 'COMP004',
              operationId: 'OP004',
              materialCode: 'MAT-BASE-001',
              description: 'Base Metálica',
              plannedQuantity: 200.0,
              unitOfMeasure: 'UN',
              warehouse: 'ALM003',
              valuationClass: 'SEMI',
              movementType: MaterialMovementType.consumption,
            ),
            MaterialComponent(
              id: 'COMP005',
              operationId: 'OP004',
              materialCode: 'MAT-FAST-001',
              description: 'Tornillería',
              plannedQuantity: 800.0,
              unitOfMeasure: 'UN',
              warehouse: 'ALM003',
              valuationClass: 'COMP',
              movementType: MaterialMovementType.consumption,
            ),
          ],
        ),
      ],
    ),
    WorkOrder(
      id: 'WO003',
      customerOrder: 'PED-2024-003',
      customerPosition: '10',
      center: 'PLANTA02',
      workStation: 'WS005',
      material: 'MAT003',
      description: 'Producto C - Urgente',
      plannedQuantity: 50.0,
      confirmedQuantity: 50.0,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().subtract(const Duration(days: 1)),
      status: WorkOrderStatus.finished,
      operations: [
        Operation(
          id: 'OP005',
          workOrderId: 'WO003',
          operationNumber: '0010',
          description: 'Fabricación Completa',
          workStation: 'WS005',
          plannedQuantity: 50.0,
          confirmedQuantity: 50.0,
          startDate: DateTime.now().subtract(const Duration(days: 5)),
          endDate: DateTime.now().subtract(const Duration(days: 1)),
          status: OperationStatus.confirmed,
          activities: [
            Activity(
              id: 'ACT009',
              operationId: 'OP005',
              type: ActivityType.directLabor,
              code: 'MOD005',
              description: 'Fabricación completa',
              plannedTime: 8.0,
              actualTime: 7.5,
              rate: 32.0,
            ),
          ],
          components: [
            MaterialComponent(
              id: 'COMP006',
              operationId: 'OP005',
              materialCode: 'MAT-SPEC-001',
              description: 'Material Especial',
              plannedQuantity: 100.0,
              actualQuantity: 98.0,
              unitOfMeasure: 'KG',
              warehouse: 'ALM004',
              batch: 'LOTE-SPEC-001',
              valuationClass: 'SPEC',
              movementType: MaterialMovementType.consumption,
              isConsumed: true,
            ),
          ],
        ),
      ],
    ),
  ];

  /// Obtiene todas las órdenes de trabajo
  static List<WorkOrder> getAllWorkOrders() {
    return List.from(_workOrders);
  }

  /// Filtra órdenes de trabajo según criterios
  static List<WorkOrder> filterWorkOrders(WorkOrderFilter filter) {
    var result = _workOrders.where((order) {
      if (filter.customerOrder != null &&
          filter.customerOrder!.isNotEmpty &&
          !order.customerOrder
              .toLowerCase()
              .contains(filter.customerOrder!.toLowerCase())) {
        return false;
      }

      if (filter.customerPosition != null &&
          filter.customerPosition!.isNotEmpty &&
          !order.customerPosition
              .toLowerCase()
              .contains(filter.customerPosition!.toLowerCase())) {
        return false;
      }

      if (filter.center != null &&
          filter.center!.isNotEmpty &&
          !order.center
              .toLowerCase()
              .contains(filter.center!.toLowerCase())) {
        return false;
      }

      if (filter.workStation != null &&
          filter.workStation!.isNotEmpty &&
          !order.workStation
              .toLowerCase()
              .contains(filter.workStation!.toLowerCase())) {
        return false;
      }

      if (filter.status != null && order.status != filter.status) {
        return false;
      }

      if (filter.startDate != null &&
          order.startDate.isBefore(filter.startDate!)) {
        return false;
      }

      if (filter.endDate != null &&
          order.endDate != null &&
          order.endDate!.isAfter(filter.endDate!.add(const Duration(days: 1)))) {
        return false;
      }

      return true;
    }).toList();

    return result;
  }

  /// Obtiene una orden de trabajo por ID
  static WorkOrder? getWorkOrderById(String id) {
    try {
      return _workOrders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene operaciones de una orden de trabajo
  static List<Operation> getOperationsForWorkOrder(String workOrderId) {
    final workOrder = getWorkOrderById(workOrderId);
    return workOrder?.operations ?? [];
  }

  /// Obtiene una operación por ID
  static Operation? getOperationById(String id) {
    for (final workOrder in _workOrders) {
      try {
        return workOrder.operations.firstWhere((op) => op.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  /// Actualiza una operación
  static bool updateOperation(Operation updatedOperation) {
    for (int i = 0; i < _workOrders.length; i++) {
      final workOrder = _workOrders[i];
      for (int j = 0; j < workOrder.operations.length; j++) {
        if (workOrder.operations[j].id == updatedOperation.id) {
          final updatedOperations = List<Operation>.from(workOrder.operations);
          updatedOperations[j] = updatedOperation;
          
          _workOrders[i] = workOrder.copyWith(operations: updatedOperations);
          return true;
        }
      }
    }
    return false;
  }

  /// Confirma una operación con cantidades y actividades
  static bool confirmOperation(
    String operationId,
    double goodQuantity,
    double rejectQuantity,
    double reworkQuantity,
    List<Activity> updatedActivities,
    List<MaterialComponent> updatedComponents,
  ) {
    final operation = getOperationById(operationId);
    if (operation == null) return false;

    final totalConfirmed = goodQuantity + rejectQuantity + reworkQuantity;
    
    final updatedOperation = operation.copyWith(
      confirmedQuantity: totalConfirmed,
      status: OperationStatus.confirmed,
      endDate: DateTime.now(),
      activities: updatedActivities,
      components: updatedComponents,
    );

    return updateOperation(updatedOperation);
  }

  /// Obtiene centros/plantas disponibles
  static List<String> getAvailableCenters() {
    return _workOrders.map((order) => order.center).toSet().toList()..sort();
  }

  /// Obtiene puestos de trabajo disponibles
  static List<String> getAvailableWorkStations() {
    return _workOrders.map((order) => order.workStation).toSet().toList()..sort();
  }

  /// Obtiene almacenes disponibles
  static List<String> getAvailableWarehouses() {
    final warehouses = <String>{};
    for (final workOrder in _workOrders) {
      for (final operation in workOrder.operations) {
        for (final component in operation.components) {
          warehouses.add(component.warehouse);
        }
      }
    }
    return warehouses.toList()..sort();
  }

  /// Busca materiales por código o descripción
  static List<MaterialComponent> searchMaterials(String query) {
    final allComponents = <MaterialComponent>[];
    for (final workOrder in _workOrders) {
      for (final operation in workOrder.operations) {
        allComponents.addAll(operation.components);
      }
    }

    if (query.isEmpty) return allComponents;

    return allComponents.where((component) {
      return component.materialCode.toLowerCase().contains(query.toLowerCase()) ||
             component.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Obtiene lotes disponibles para un material
  static List<String> getAvailableBatches(String materialCode) {
    final batches = <String>{};
    for (final workOrder in _workOrders) {
      for (final operation in workOrder.operations) {
        for (final component in operation.components) {
          if (component.materialCode == materialCode && component.batch != null) {
            batches.add(component.batch!);
          }
        }
      }
    }
    return batches.toList()..sort();
  }

  /// Simula validación de stock
  static bool validateStock(String materialCode, String warehouse, double quantity) {
    // En una implementación real, esto consultaría el sistema de inventario
    // Por ahora, simulamos que siempre hay stock suficiente
    return true;
  }

  /// Simula validación de lote
  static bool validateBatch(String materialCode, String batch) {
    // En una implementación real, esto validaría fechas de vencimiento, 
    // disponibilidad, etc.
    return true;
  }

  /// Obtiene trabajo del día (operaciones abiertas)
  static List<Operation> getTodaysWork() {
    final today = DateTime.now();
    final operations = <Operation>[];
    
    for (final workOrder in _workOrders) {
      for (final operation in workOrder.operations) {
        // Operaciones que están programadas para hoy o están en progreso
        if (operation.status == OperationStatus.started ||
            operation.status == OperationStatus.released ||
            (operation.startDate != null &&
             operation.startDate!.day == today.day &&
             operation.startDate!.month == today.month &&
             operation.startDate!.year == today.year)) {
          operations.add(operation);
        }
      }
    }
    
    return operations;
  }

  /// Calcula el total de costos de actividades
  static double calculateTotalActivityCost(List<Activity> activities) {
    return activities.fold(0.0, (sum, activity) => sum + activity.calculatedCost);
  }

  /// Genera sugerencias de componentes basadas en BOM o última confirmación
  static List<MaterialComponent> suggestComponents(String operationId) {
    final operation = getOperationById(operationId);
    if (operation == null) return [];

    // En una implementación real, esto consultaría la lista de materiales (BOM)
    // o la última confirmación similar
    return operation.components;
  }
}