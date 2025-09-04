import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import '../../models/models.dart';
import '../../widgets/transaction_widgets/transaction_list.dart';
import '../login_screen.dart';

class HomeStyle4 extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const HomeStyle4({super.key, required this.onThemeToggle});

  @override
  State<HomeStyle4> createState() => _HomeStyle4State();
}

class _HomeStyle4State extends State<HomeStyle4> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = AuthService.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Wallet - Simple'),
        titleTextStyle: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.light 
                  ? Icons.dark_mode 
                  : Icons.light_mode,
              size: 32,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Cambiar tema',
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 32),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildMainPage(context, user),
          _buildActionsPage(context),
          _buildTransactionsPage(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: theme.textTheme.titleMedium,
        iconSize: 32,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Acciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
    );
  }

  Widget _buildMainPage(BuildContext context, User user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cards = WalletService.getCards();
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Welcome message
            Text(
              '¡Hola, ${user.name}!',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Balance display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: colorScheme.onPrimaryContainer,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu Saldo',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    WalletService.formatCurrency(user.balance),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Current card
            Text(
              'Tarjeta Principal',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    cards.first.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    cards.first.number,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${cards.first.type} • Vence ${cards.first.expiryDate}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsPage(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            Text(
              '¿Qué quieres hacer?',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            Expanded(
              child: Column(
                children: [
                  _buildLargeButton(
                    context,
                    icon: Icons.send,
                    label: 'Enviar Dinero',
                    color: Colors.blue,
                    onTap: () => _showComingSoon(context, 'Enviar dinero'),
                  ),
                  const SizedBox(height: 20),
                  _buildLargeButton(
                    context,
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear QR',
                    color: Colors.purple,
                    onTap: () => _showComingSoon(context, 'Escanear QR'),
                  ),
                  const SizedBox(height: 20),
                  _buildLargeButton(
                    context,
                    icon: Icons.add_circle,
                    label: 'Recargar Saldo',
                    color: Colors.green,
                    onTap: () => _showComingSoon(context, 'Recargar saldo'),
                  ),
                  const SizedBox(height: 20),
                  _buildLargeButton(
                    context,
                    icon: Icons.payment,
                    label: 'Pagar Ahora',
                    color: Colors.orange,
                    onTap: () => _showComingSoon(context, 'Realizar pago'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsPage(BuildContext context) {
    final theme = Theme.of(context);
    final transactions = WalletService.getRecentTransactions();
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            Text(
              'Tu Actividad',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 30),
            
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getTransactionIcon(transaction.type),
                              size: 32,
                              color: _getTransactionColor(transaction.type),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                transaction.description,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          WalletService.formatTransactionAmount(transaction.amount),
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: transaction.amount >= 0 
                                ? Colors.green.shade600 
                                : Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(transaction.date),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(width: 16),
            Text(
              label,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return Icons.shopping_cart;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.topup:
        return Icons.add_circle;
      case TransactionType.refund:
        return Icons.undo;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.payment:
        return Colors.blue;
      case TransactionType.transfer:
        return Colors.orange;
      case TransactionType.topup:
        return Colors.green;
      case TransactionType.refund:
        return Colors.purple;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} minutos';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Próximamente',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '$feature estará disponible próximamente.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Entendido',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cerrar Sesión',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
            child: Text(
              'Cerrar Sesión',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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