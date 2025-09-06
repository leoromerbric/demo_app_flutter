import 'package:flutter/material.dart';

/// Estado de una orden de trabajo
enum WorkOrderStatus {
  created,      // Creada
  released,     // Liberada
  started,      // Iniciada
  finished,     // Terminada
  closed        // Cerrada
}

/// Estado de una operación
enum OperationStatus {
  created,      // Creada
  released,     // Liberada
  started,      // Iniciada
  finished,     // Terminada
  confirmed     // Confirmada
}

/// Tipo de movimiento de material
enum MaterialMovementType {
  consumption,  // Egreso/Consumo
  return,       // Devolución
  receipt       // Recepción (opcional)
}

/// Tipo de actividad
enum ActivityType {
  directLabor,      // Mano de obra directa (MOD)
  indirectLabor,    // Indirectos
  energy,           // Energía
  depreciation,     // Depreciación
  other            // Otros
}

/// Orden de trabajo
class WorkOrder {
  final String id;
  final String customerOrder;     // Pedido cliente
  final String customerPosition;  // Posición cliente
  final String center;           // Centro/Planta
  final String workStation;      // Puesto de trabajo
  final String material;         // Material
  final String description;      // Descripción
  final double plannedQuantity;  // Cantidad planificada
  final double confirmedQuantity; // Cantidad confirmada
  final DateTime startDate;     // Fecha inicio
  final DateTime? endDate;      // Fecha fin
  final WorkOrderStatus status; // Estado
  final List<Operation> operations; // Operaciones

  const WorkOrder({
    required this.id,
    required this.customerOrder,
    required this.customerPosition,
    required this.center,
    required this.workStation,
    required this.material,
    required this.description,
    required this.plannedQuantity,
    this.confirmedQuantity = 0.0,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.operations,
  });

  WorkOrder copyWith({
    String? id,
    String? customerOrder,
    String? customerPosition,
    String? center,
    String? workStation,
    String? material,
    String? description,
    double? plannedQuantity,
    double? confirmedQuantity,
    DateTime? startDate,
    DateTime? endDate,
    WorkOrderStatus? status,
    List<Operation>? operations,
  }) {
    return WorkOrder(
      id: id ?? this.id,
      customerOrder: customerOrder ?? this.customerOrder,
      customerPosition: customerPosition ?? this.customerPosition,
      center: center ?? this.center,
      workStation: workStation ?? this.workStation,
      material: material ?? this.material,
      description: description ?? this.description,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      confirmedQuantity: confirmedQuantity ?? this.confirmedQuantity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      operations: operations ?? this.operations,
    );
  }
}

/// Operación de una orden de trabajo
class Operation {
  final String id;
  final String workOrderId;
  final String operationNumber;
  final String description;
  final String workStation;
  final double plannedQuantity;
  final double confirmedQuantity;
  final DateTime? startDate;
  final DateTime? endDate;
  final OperationStatus status;
  final List<Activity> activities;
  final List<MaterialComponent> components;

  const Operation({
    required this.id,
    required this.workOrderId,
    required this.operationNumber,
    required this.description,
    required this.workStation,
    required this.plannedQuantity,
    this.confirmedQuantity = 0.0,
    this.startDate,
    this.endDate,
    required this.status,
    required this.activities,
    required this.components,
  });

  Operation copyWith({
    String? id,
    String? workOrderId,
    String? operationNumber,
    String? description,
    String? workStation,
    double? plannedQuantity,
    double? confirmedQuantity,
    DateTime? startDate,
    DateTime? endDate,
    OperationStatus? status,
    List<Activity>? activities,
    List<MaterialComponent>? components,
  }) {
    return Operation(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      operationNumber: operationNumber ?? this.operationNumber,
      description: description ?? this.description,
      workStation: workStation ?? this.workStation,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      confirmedQuantity: confirmedQuantity ?? this.confirmedQuantity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      activities: activities ?? this.activities,
      components: components ?? this.components,
    );
  }
}

/// Actividad de una operación (tarifa)
class Activity {
  final String id;
  final String operationId;
  final ActivityType type;
  final String code;
  final String description;
  final double plannedTime;    // Tiempo planificado (horas)
  final double actualTime;     // Tiempo real (horas)
  final double rate;           // Tarifa por hora
  final double totalCost;      // Costo total

  const Activity({
    required this.id,
    required this.operationId,
    required this.type,
    required this.code,
    required this.description,
    required this.plannedTime,
    this.actualTime = 0.0,
    required this.rate,
    this.totalCost = 0.0,
  });

  Activity copyWith({
    String? id,
    String? operationId,
    ActivityType? type,
    String? code,
    String? description,
    double? plannedTime,
    double? actualTime,
    double? rate,
    double? totalCost,
  }) {
    return Activity(
      id: id ?? this.id,
      operationId: operationId ?? this.operationId,
      type: type ?? this.type,
      code: code ?? this.code,
      description: description ?? this.description,
      plannedTime: plannedTime ?? this.plannedTime,
      actualTime: actualTime ?? this.actualTime,
      rate: rate ?? this.rate,
      totalCost: totalCost ?? this.totalCost,
    );
  }

  double get calculatedCost => actualTime * rate;
}

/// Componente de material
class MaterialComponent {
  final String id;
  final String operationId;
  final String materialCode;
  final String description;
  final double plannedQuantity;
  final double actualQuantity;
  final String unitOfMeasure;   // UoM (KG, M³, UN, etc.)
  final String warehouse;       // Almacén
  final String? batch;          // Lote
  final String valuationClass;  // Clase de valoración
  final MaterialMovementType movementType;
  final bool isConsumed;        // Marcado como consumido

  const MaterialComponent({
    required this.id,
    required this.operationId,
    required this.materialCode,
    required this.description,
    required this.plannedQuantity,
    this.actualQuantity = 0.0,
    required this.unitOfMeasure,
    required this.warehouse,
    this.batch,
    required this.valuationClass,
    this.movementType = MaterialMovementType.consumption,
    this.isConsumed = false,
  });

  MaterialComponent copyWith({
    String? id,
    String? operationId,
    String? materialCode,
    String? description,
    double? plannedQuantity,
    double? actualQuantity,
    String? unitOfMeasure,
    String? warehouse,
    String? batch,
    String? valuationClass,
    MaterialMovementType? movementType,
    bool? isConsumed,
  }) {
    return MaterialComponent(
      id: id ?? this.id,
      operationId: operationId ?? this.operationId,
      materialCode: materialCode ?? this.materialCode,
      description: description ?? this.description,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      actualQuantity: actualQuantity ?? this.actualQuantity,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      warehouse: warehouse ?? this.warehouse,
      batch: batch ?? this.batch,
      valuationClass: valuationClass ?? this.valuationClass,
      movementType: movementType ?? this.movementType,
      isConsumed: isConsumed ?? this.isConsumed,
    );
  }
}

/// Filtros para búsqueda de órdenes de trabajo
class WorkOrderFilter {
  final String? customerOrder;
  final String? customerPosition;
  final String? center;
  final String? workStation;
  final DateTime? startDate;
  final DateTime? endDate;
  final WorkOrderStatus? status;

  const WorkOrderFilter({
    this.customerOrder,
    this.customerPosition,
    this.center,
    this.workStation,
    this.startDate,
    this.endDate,
    this.status,
  });

  WorkOrderFilter copyWith({
    String? customerOrder,
    String? customerPosition,
    String? center,
    String? workStation,
    DateTime? startDate,
    DateTime? endDate,
    WorkOrderStatus? status,
  }) {
    return WorkOrderFilter(
      customerOrder: customerOrder ?? this.customerOrder,
      customerPosition: customerPosition ?? this.customerPosition,
      center: center ?? this.center,
      workStation: workStation ?? this.workStation,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  bool get hasFilters =>
      customerOrder != null ||
      customerPosition != null ||
      center != null ||
      workStation != null ||
      startDate != null ||
      endDate != null ||
      status != null;
}

/// Extensiones para obtener texto localizado
extension WorkOrderStatusExtension on WorkOrderStatus {
  String get displayName {
    switch (this) {
      case WorkOrderStatus.created:
        return 'Creada';
      case WorkOrderStatus.released:
        return 'Liberada';
      case WorkOrderStatus.started:
        return 'Iniciada';
      case WorkOrderStatus.finished:
        return 'Terminada';
      case WorkOrderStatus.closed:
        return 'Cerrada';
    }
  }

  Color get color {
    switch (this) {
      case WorkOrderStatus.created:
        return Colors.grey;
      case WorkOrderStatus.released:
        return Colors.blue;
      case WorkOrderStatus.started:
        return Colors.orange;
      case WorkOrderStatus.finished:
        return Colors.green;
      case WorkOrderStatus.closed:
        return Colors.red;
    }
  }
}

extension OperationStatusExtension on OperationStatus {
  String get displayName {
    switch (this) {
      case OperationStatus.created:
        return 'Creada';
      case OperationStatus.released:
        return 'Liberada';
      case OperationStatus.started:
        return 'Iniciada';
      case OperationStatus.finished:
        return 'Terminada';
      case OperationStatus.confirmed:
        return 'Confirmada';
    }
  }

  Color get color {
    switch (this) {
      case OperationStatus.created:
        return Colors.grey;
      case OperationStatus.released:
        return Colors.blue;
      case OperationStatus.started:
        return Colors.orange;
      case OperationStatus.finished:
        return Colors.green;
      case OperationStatus.confirmed:
        return Colors.purple;
    }
  }
}

extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.directLabor:
        return 'Mano de Obra Directa';
      case ActivityType.indirectLabor:
        return 'Indirectos';
      case ActivityType.energy:
        return 'Energía';
      case ActivityType.depreciation:
        return 'Depreciación';
      case ActivityType.other:
        return 'Otros';
    }
  }

  String get shortName {
    switch (this) {
      case ActivityType.directLabor:
        return 'MOD';
      case ActivityType.indirectLabor:
        return 'IND';
      case ActivityType.energy:
        return 'ENE';
      case ActivityType.depreciation:
        return 'DEP';
      case ActivityType.other:
        return 'OTR';
    }
  }
}

extension MaterialMovementTypeExtension on MaterialMovementType {
  String get displayName {
    switch (this) {
      case MaterialMovementType.consumption:
        return 'Egreso/Consumo';
      case MaterialMovementType.return:
        return 'Devolución';
      case MaterialMovementType.receipt:
        return 'Recepción';
    }
  }

  IconData get icon {
    switch (this) {
      case MaterialMovementType.consumption:
        return Icons.arrow_downward;
      case MaterialMovementType.return:
        return Icons.arrow_upward;
      case MaterialMovementType.receipt:
        return Icons.arrow_forward;
    }
  }
}