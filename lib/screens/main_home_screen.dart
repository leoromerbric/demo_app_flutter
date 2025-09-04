import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/wallet_service.dart';
import '../models/models.dart';
import '../widgets/cards/wallet_card_widget.dart';
import '../widgets/transaction_widgets/transaction_list.dart';
import 'login_screen.dart';
import 'home_selector_screen.dart';

class MainHomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const MainHomeScreen({super.key, required this.onThemeToggle});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Wallet'),
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
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'styles':
                  _navigateToStyleSelector();
                  break;
                case 'logout':
                  _logout(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'styles',
                child: ListTile(
                  leading: Icon(Icons.palette),
                  title: Text('Cambiar Estilo'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesión'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomePage(context, user),
          _buildCardsPage(context),
          _buildTransactionsPage(context),
          _buildProfilePage(context, user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Tarjetas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Actividad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, User user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cards = WalletService.getCards();
    final transactions = WalletService.getRecentTransactions();
    
    return SafeArea(
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
            const SizedBox(height: 16),
            
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo Total',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        WalletService.formatCurrency(user.balance),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            
            // Action grid
            SizedBox(
              height: 160,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.send,
                    label: 'Enviar',
                    color: Colors.blue,
                    onTap: () => _showComingSoon(context, 'Enviar dinero'),
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear',
                    color: Colors.purple,
                    onTap: () => _showComingSoon(context, 'Escanear QR'),
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.add_circle,
                    label: 'Recargar',
                    color: Colors.green,
                    onTap: () => _showComingSoon(context, 'Recargar saldo'),
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.payment,
                    label: 'Pagar',
                    color: Colors.orange,
                    onTap: () => _showComingSoon(context, 'Realizar pago'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent transactions preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transacciones Recientes',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Show only first 3 transactions
            ...transactions.take(3).map((transaction) =>
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTransactionColor(transaction.type).withOpacity(0.1),
                    child: Icon(
                      _getTransactionIcon(transaction.type),
                      color: _getTransactionColor(transaction.type),
                    ),
                  ),
                  title: Text(transaction.description),
                  subtitle: Text(_formatDate(transaction.date)),
                  trailing: Text(
                    WalletService.formatTransactionAmount(transaction.amount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.amount >= 0 
                          ? Colors.green.shade600 
                          : Colors.red.shade600,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ).toList(),
            
            // Bottom padding for navigation bar
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsPage(BuildContext context) {
    final theme = Theme.of(context);
    final cards = WalletService.getCards();
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Tarjetas',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 200,
                      child: WalletCardWidget(card: cards[index]),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showComingSoon(context, 'Añadir tarjeta'),
                icon: const Icon(Icons.add),
                label: const Text('Añadir Nueva Tarjeta'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Todas las Transacciones',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => _showComingSoon(context, 'Filtros'),
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filtrar transacciones',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: TransactionList(
                transactions: transactions,
                showAll: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context, User user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile options
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    context,
                    icon: Icons.palette,
                    title: 'Cambiar Estilo de Interfaz',
                    subtitle: 'Elige entre diferentes estilos de UI',
                    onTap: _navigateToStyleSelector,
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.security,
                    title: 'Seguridad',
                    subtitle: 'Configurar PIN y contraseñas',
                    onTap: () => _showComingSoon(context, 'Configuración de seguridad'),
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    subtitle: 'Gestionar alertas y notificaciones',
                    onTap: () => _showComingSoon(context, 'Configuración de notificaciones'),
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.help,
                    title: 'Ayuda y Soporte',
                    subtitle: 'Obtener ayuda con la aplicación',
                    onTap: () => _showComingSoon(context, 'Centro de ayuda'),
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.info,
                    title: 'Acerca de',
                    subtitle: 'Información de la aplicación',
                    onTap: () => _showComingSoon(context, 'Información de la app'),
                  ),
                  const Divider(),
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    title: 'Cerrar Sesión',
                    subtitle: 'Salir de tu cuenta',
                    onTap: () => _logout(context),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
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

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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

  void _navigateToStyleSelector() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeSelectorScreen(onThemeToggle: widget.onThemeToggle),
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