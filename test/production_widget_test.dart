import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_wallet/screens/production/work_order_list_screen.dart';
import 'package:mi_wallet/models/production_models.dart';

void main() {
  group('Production Screen Widget Tests', () {
    testWidgets('WorkOrderListScreen displays correctly', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: WorkOrderListScreen(
            onThemeToggle: () {},
          ),
        ),
      );

      // Verify that the screen shows the app bar title
      expect(find.text('Órdenes de Trabajo'), findsOneWidget);
      
      // Verify that filter and refresh buttons are present
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      
      // Wait for loading to complete
      await tester.pump(const Duration(milliseconds: 600));
      
      // Should show work orders after loading
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('WorkOrderListScreen filter toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkOrderListScreen(
            onThemeToggle: () {},
          ),
        ),
      );

      // Initially filters should be hidden
      expect(find.text('Pedido Cliente'), findsNothing);
      
      // Tap filter button
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      
      // Now filters should be visible
      expect(find.text('Pedido Cliente'), findsOneWidget);
      expect(find.text('Posición'), findsOneWidget);
      expect(find.text('Centro/Planta'), findsOneWidget);
      
      // Tap filter button again to hide
      await tester.tap(find.byIcon(Icons.filter_list_off));
      await tester.pump();
      
      // Filters should be hidden again
      expect(find.text('Pedido Cliente'), findsNothing);
    });

    testWidgets('Material movement type extension works correctly', (WidgetTester tester) async {
      // Test display names
      expect(MaterialMovementType.consumption.displayName, 'Egreso/Consumo');
      expect(MaterialMovementType.return.displayName, 'Devolución');
      expect(MaterialMovementType.receipt.displayName, 'Recepción');
      
      // Test icons
      expect(MaterialMovementType.consumption.icon, Icons.arrow_downward);
      expect(MaterialMovementType.return.icon, Icons.arrow_upward);
      expect(MaterialMovementType.receipt.icon, Icons.arrow_forward);
    });

    testWidgets('Activity type extension works correctly', (WidgetTester tester) async {
      // Test display names
      expect(ActivityType.directLabor.displayName, 'Mano de Obra Directa');
      expect(ActivityType.indirectLabor.displayName, 'Indirectos');
      expect(ActivityType.energy.displayName, 'Energía');
      expect(ActivityType.depreciation.displayName, 'Depreciación');
      expect(ActivityType.other.displayName, 'Otros');
      
      // Test short names
      expect(ActivityType.directLabor.shortName, 'MOD');
      expect(ActivityType.indirectLabor.shortName, 'IND');
      expect(ActivityType.energy.shortName, 'ENE');
      expect(ActivityType.depreciation.shortName, 'DEP');
      expect(ActivityType.other.shortName, 'OTR');
    });

    testWidgets('Work order status extension works correctly', (WidgetTester tester) async {
      // Test display names
      expect(WorkOrderStatus.created.displayName, 'Creada');
      expect(WorkOrderStatus.released.displayName, 'Liberada');
      expect(WorkOrderStatus.started.displayName, 'Iniciada');
      expect(WorkOrderStatus.finished.displayName, 'Terminada');
      expect(WorkOrderStatus.closed.displayName, 'Cerrada');
      
      // Test colors are assigned
      expect(WorkOrderStatus.created.color, Colors.grey);
      expect(WorkOrderStatus.released.color, Colors.blue);
      expect(WorkOrderStatus.started.color, Colors.orange);
      expect(WorkOrderStatus.finished.color, Colors.green);
      expect(WorkOrderStatus.closed.color, Colors.red);
    });

    testWidgets('Operation status extension works correctly', (WidgetTester tester) async {
      // Test display names
      expect(OperationStatus.created.displayName, 'Creada');
      expect(OperationStatus.released.displayName, 'Liberada');
      expect(OperationStatus.started.displayName, 'Iniciada');
      expect(OperationStatus.finished.displayName, 'Terminada');
      expect(OperationStatus.confirmed.displayName, 'Confirmada');
      
      // Test colors are assigned
      expect(OperationStatus.created.color, Colors.grey);
      expect(OperationStatus.released.color, Colors.blue);
      expect(OperationStatus.started.color, Colors.orange);
      expect(OperationStatus.finished.color, Colors.green);
      expect(OperationStatus.confirmed.color, Colors.purple);
    });
  });
}