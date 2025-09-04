import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import '../../models/models.dart';
import '../../widgets/cards/wallet_card_widget.dart';
import '../../widgets/transaction_widgets/transaction_list.dart';
import '../login_screen.dart';

class HomeStyle1 extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const HomeStyle1({super.key, required this.onThemeToggle});

  @override
  State<HomeStyle1> createState() => _HomeStyle1State();
}

class _HomeStyle1State extends State<HomeStyle1> {
  late PageController _pageController;
  int _currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = AuthService.currentUser!;
    final cards = WalletService.getCards();
    final transactions = WalletService.getRecentTransactions();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Wallet - Clásico'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Text(
                '¡Hola, ${user.name}!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: colorScheme.onPrimaryContainer,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo Total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          WalletService.formatCurrency(user.balance),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Cards section
              Text(
                'Mis Tarjetas',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentCardIndex = index;
                    });
                  },
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: WalletCardWidget(card: cards[index]),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Card indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: cards.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCardIndex == entry.key
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Quick actions
              Text(
                'Acciones Rápidas',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.send,
                      label: 'Enviar',
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.qr_code_scanner,
                      label: 'Escanear',
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.add,
                      label: 'Recargar',
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.more_horiz,
                      label: 'Más',
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Recent transactions
              Text(
                'Transacciones Recientes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TransactionList(transactions: transactions),
              
              // Add bottom padding to ensure content doesn't get cut off
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad próximamente disponible'),
        duration: Duration(seconds: 2),
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
                  builder: (context) => LoginScreen(onThemeToggle: widget.onThemeToggle),
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}