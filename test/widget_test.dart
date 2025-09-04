import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_wallet/main.dart';

void main() {
  testWidgets('Mi Wallet app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MiWalletApp());

    // Verify that the login screen is displayed
    expect(find.text('Mi Wallet'), findsOneWidget);
    expect(find.text('¡Bienvenido!'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
  });

  testWidgets('Login screen should be scrollable to prevent overflow', (WidgetTester tester) async {
    // Set a smaller screen size to simulate overflow conditions
    await tester.binding.setSurfaceSize(const Size(400, 600));
    await tester.pumpWidget(const MiWalletApp());

    // Verify that SingleChildScrollView is present (no overflow)
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    
    // Verify all login elements are still findable (content is accessible)
    expect(find.text('¡Bienvenido!'), findsOneWidget);
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Credenciales de prueba:'), findsOneWidget);

    // Simulate scrolling to verify scrollability
    await tester.scrollUntilVisible(
      find.text('Credenciales de prueba:'),
      500.0,
    );
    expect(find.text('Credenciales de prueba:'), findsOneWidget);
    
    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Login with valid credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MiWalletApp());

    // Enter valid credentials
    await tester.enterText(find.byType(TextFormField).first, 'leonel');
    await tester.enterText(find.byType(TextFormField).last, '1234');
    
    // Tap the login button
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pumpAndSettle();

    // Verify navigation to main home screen
    expect(find.text('Mi Wallet'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Tarjetas'), findsOneWidget);
    expect(find.text('Actividad'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}
