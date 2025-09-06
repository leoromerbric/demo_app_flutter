import 'package:flutter_test/flutter_test.dart';
import 'package:mi_wallet/models/production_models.dart';
import 'package:mi_wallet/services/production_service.dart';

void main() {
  group('Production Management Integration Tests', () {
    test('Complete workflow: Filter -> Select -> Confirm -> Components', () {
      // Test 1: Filter work orders
      final filter = WorkOrderFilter(
        center: 'PLANTA01',
        status: WorkOrderStatus.started,
      );
      
      final workOrders = ProductionService.filterWorkOrders(filter);
      expect(workOrders.isNotEmpty, true);
      
      final workOrder = workOrders.first;
      expect(workOrder.center, 'PLANTA01');
      expect(workOrder.status, WorkOrderStatus.started);
      
      // Test 2: Get operations for work order
      final operations = ProductionService.getOperationsForWorkOrder(workOrder.id);
      expect(operations.isNotEmpty, true);
      
      final operation = operations.first;
      expect(operation.workOrderId, workOrder.id);
      
      // Test 3: Confirm operation
      final success = ProductionService.confirmOperation(
        operation.id,
        50.0, // good quantity
        2.0,  // reject quantity
        1.0,  // rework quantity
        operation.activities,
        operation.components,
      );
      expect(success, true);
      
      // Test 4: Verify operation was updated
      final updatedOperation = ProductionService.getOperationById(operation.id);
      expect(updatedOperation?.status, OperationStatus.confirmed);
      expect(updatedOperation?.confirmedQuantity, 53.0); // 50 + 2 + 1
    });
    
    test('Activity cost calculation', () {
      final activity = Activity(
        id: 'test',
        operationId: 'test',
        type: ActivityType.directLabor,
        code: 'MOD001',
        description: 'Test activity',
        plannedTime: 4.0,
        actualTime: 3.5,
        rate: 25.0,
      );
      
      expect(activity.calculatedCost, 87.5); // 3.5 * 25.0
    });
    
    test('Material component types and display names', () {
      expect(MaterialMovementType.consumption.displayName, 'Egreso/Consumo');
      expect(MaterialMovementType.return.displayName, 'Devolución');
      expect(MaterialMovementType.receipt.displayName, 'Recepción');
      
      expect(ActivityType.directLabor.shortName, 'MOD');
      expect(ActivityType.energy.shortName, 'ENE');
      expect(ActivityType.depreciation.shortName, 'DEP');
    });
    
    test('Work order status progression', () {
      final statuses = WorkOrderStatus.values;
      expect(statuses.length, 5);
      
      expect(WorkOrderStatus.created.displayName, 'Creada');
      expect(WorkOrderStatus.released.displayName, 'Liberada');
      expect(WorkOrderStatus.started.displayName, 'Iniciada');
      expect(WorkOrderStatus.finished.displayName, 'Terminada');
      expect(WorkOrderStatus.closed.displayName, 'Cerrada');
    });
    
    test('Service helper methods', () {
      final centers = ProductionService.getAvailableCenters();
      expect(centers.isNotEmpty, true);
      expect(centers.contains('PLANTA01'), true);
      
      final workStations = ProductionService.getAvailableWorkStations();
      expect(workStations.isNotEmpty, true);
      
      final todaysWork = ProductionService.getTodaysWork();
      expect(todaysWork.isNotEmpty, true);
      
      final totalCost = ProductionService.calculateTotalActivityCost([
        Activity(
          id: '1',
          operationId: '1',
          type: ActivityType.directLabor,
          code: 'MOD001',
          description: 'Test 1',
          plannedTime: 2.0,
          actualTime: 2.0,
          rate: 10.0,
        ),
        Activity(
          id: '2',
          operationId: '1',
          type: ActivityType.energy,
          code: 'ENE001',
          description: 'Test 2',
          plannedTime: 1.0,
          actualTime: 1.0,
          rate: 5.0,
        ),
      ]);
      expect(totalCost, 25.0); // (2*10) + (1*5)
    });
    
    test('Filter validation', () {
      const emptyFilter = WorkOrderFilter();
      expect(emptyFilter.hasFilters, false);
      
      const filterWithData = WorkOrderFilter(
        customerOrder: 'PED-2024-001',
        center: 'PLANTA01',
      );
      expect(filterWithData.hasFilters, true);
    });
    
    test('Material component creation and updates', () {
      const component = MaterialComponent(
        id: 'test',
        operationId: 'op1',
        materialCode: 'MAT001',
        description: 'Test Material',
        plannedQuantity: 100.0,
        actualQuantity: 95.0,
        unitOfMeasure: 'KG',
        warehouse: 'ALM001',
        batch: 'LOTE001',
        valuationClass: 'RAW',
        movementType: MaterialMovementType.consumption,
        isConsumed: false,
      );
      
      expect(component.materialCode, 'MAT001');
      expect(component.isConsumed, false);
      
      final updatedComponent = component.copyWith(
        actualQuantity: 98.0,
        isConsumed: true,
      );
      
      expect(updatedComponent.actualQuantity, 98.0);
      expect(updatedComponent.isConsumed, true);
      expect(updatedComponent.materialCode, 'MAT001'); // unchanged
    });
  });
}