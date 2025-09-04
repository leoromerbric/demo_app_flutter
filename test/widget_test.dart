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

  testWidgets('Login with valid credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MiWalletApp());

    // Enter valid credentials
    await tester.enterText(find.byType(TextFormField).first, 'leonel');
    await tester.enterText(find.byType(TextFormField).last, '1234');
    
    // Tap the login button
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pumpAndSettle();

    // Verify navigation to home selector
    expect(find.text('Seleccionar Estilo'), findsOneWidget);
  });
}