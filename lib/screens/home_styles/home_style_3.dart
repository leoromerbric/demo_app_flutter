import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import '../../models/models.dart';
import '../../widgets/cards/wallet_card_widget.dart';
import '../../widgets/transaction_widgets/transaction_list.dart';
import '../login_screen.dart';

class HomeStyle3 extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const HomeStyle3({super.key, required this.onThemeToggle});

  @override
  State<HomeStyle3> createState() => _HomeStyle3State();
}

class _HomeStyle3State extends State<HomeStyle3> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = AuthService.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Wallet - Moderno'),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard),
              text: 'Panel',
            ),
            Tab(
              icon: Icon(Icons.credit_card),
              text: 'Tarjetas',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Actividad',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(context, user),
          _buildCardsTab(context),
          _buildActivityTab(context),
        ],
      ),
    );
  }

  Widget _buildDashboardTab(BuildContext context, User user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, ${user.name}!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bienvenido de vuelta',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Total',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    WalletService.formatCurrency(user.balance),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    context,
                    icon: Icons.send,
                    label: 'Enviar',
                    color: Colors.blue,
                    onTap: () => _showComingSoon(context, 'Enviar dinero'),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear',
                    color: Colors.purple,
                    onTap: () => _showComingSoon(context, 'Escanear QR'),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.add_circle,
                    label: 'Recargar',
                    color: Colors.green,
                    onTap: () => _showComingSoon(context, 'Recargar saldo'),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.payment,
                    label: 'Pagar',
                    color: Colors.orange,
                    onTap: () => _showComingSoon(context, 'Realizar pago'),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.swap_horiz,
                    label: 'Transferir',
                    color: Colors.teal,
                    onTap: () => _showComingSoon(context, 'Transferir'),
                  ),
                  _buildActionCard(
                    context,
                    icon: Icons.settings,
                    label: 'Configurar',
                    color: Colors.grey,
                    onTap: () => _showComingSoon(context, 'Configuración'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsTab(BuildContext context) {
    final cards = WalletService.getCards();
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Tarjetas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildActivityTab(BuildContext context) {
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
                  'Actividad Reciente',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
    _tabController.dispose();
    super.dispose();
  }
}