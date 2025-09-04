import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import '../../widgets/transaction_widgets/transaction_list.dart';
import '../login_screen.dart';

class HomeStyle2 extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeStyle2({super.key, required this.onThemeToggle});

  @override
  State<HomeStyle2> createState() => _HomeStyle2State();
}

class _HomeStyle2State extends State<HomeStyle2> {
  int _selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = AuthService.currentUser!;
    final cards = WalletService.getCards();
    final transactions = WalletService.getRecentTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Wallet - Accesible'),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Welcome section with large text
            Semantics(
              label: 'Sección de bienvenida y saldo',
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outline, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, ${user.name}!',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      semanticsLabel: 'Saludo, Hola ${user.name}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: colorScheme.onPrimaryContainer,
                          size: 40,
                          semanticLabel: 'Icono de cartera',
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tu saldo total es:',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              WalletService.formatCurrency(user.balance),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              semanticsLabel:
                                  'Saldo total: ${WalletService.formatCurrency(user.balance)} pesos',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Card selection with high contrast
            Semantics(
              label: 'Selección de tarjetas',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccionar Tarjeta',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...cards.asMap().entries.map((entry) {
                    final index = entry.key;
                    final card = entry.value;
                    final isSelected = _selectedCardIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Semantics(
                        label:
                            'Tarjeta ${card.name}, número ${card.number}, ${isSelected ? 'seleccionada' : 'no seleccionada'}',
                        button: true,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCardIndex = index;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Tarjeta ${card.name} seleccionada',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.name,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? colorScheme
                                                        .onPrimaryContainer
                                                  : colorScheme
                                                        .onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        card.number,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: isSelected
                                                  ? colorScheme
                                                        .onPrimaryContainer
                                                  : colorScheme
                                                        .onSurfaceVariant,
                                            ),
                                      ),
                                      Text(
                                        '${card.type} • Vence ${card.expiryDate}',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: isSelected
                                                  ? colorScheme
                                                        .onPrimaryContainer
                                                  : colorScheme
                                                        .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Large action buttons
            Semantics(
              label: 'Acciones principales',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones Principales',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLargeActionButton(
                    context,
                    icon: Icons.send,
                    label: 'Enviar Dinero',
                    description: 'Transfiere dinero a otros usuarios',
                    onTap: () => _showComingSoon(context, 'Enviar dinero'),
                  ),
                  const SizedBox(height: 12),
                  _buildLargeActionButton(
                    context,
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear QR',
                    description: 'Paga escaneando códigos QR',
                    onTap: () => _showComingSoon(context, 'Escanear QR'),
                  ),
                  const SizedBox(height: 12),
                  _buildLargeActionButton(
                    context,
                    icon: Icons.add_circle,
                    label: 'Recargar Saldo',
                    description: 'Añade dinero a tu cartera',
                    onTap: () => _showComingSoon(context, 'Recargar saldo'),
                  ),
                  const SizedBox(height: 12),
                  _buildLargeActionButton(
                    context,
                    icon: Icons.payment,
                    label: 'Pagar',
                    description: 'Realiza pagos rápidos',
                    onTap: () => _showComingSoon(context, 'Realizar pago'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Recent transactions with accessibility focus
            Semantics(
              label: 'Historial de transacciones recientes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transacciones Recientes',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TransactionList(transactions: transactions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: '$label. $description',
      button: true,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimaryContainer,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature estará disponible próximamente'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              AuthService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      LoginScreen(onThemeToggle: widget.onThemeToggle),
                ),
                (route) => false,
              );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
