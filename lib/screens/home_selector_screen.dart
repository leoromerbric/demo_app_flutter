import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_styles/home_style_1.dart';
import 'home_styles/home_style_2.dart';
import 'home_styles/home_style_3.dart';
import 'home_styles/home_style_4.dart';
import 'home_styles/home_style_5.dart';

class HomeSelectorScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  
  const HomeSelectorScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = AuthService.currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seleccionar Estilo',
          semanticsLabel: 'Seleccionar estilo de interfaz',
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.light 
                  ? Icons.dark_mode 
                  : Icons.light_mode,
            ),
            onPressed: onThemeToggle,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, ${user.name}!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona el estilo de interfaz que prefieras para tu cartera:',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildStyleCard(
                      context,
                      title: 'Estilo Clásico',
                      description: 'Diseño tradicional con tarjetas',
                      icon: Icons.credit_card,
                      color: const Color(0xFF1976D2),
                      onTap: () => _navigateToStyle(context, 1),
                    ),
                    _buildStyleCard(
                      context,
                      title: 'Estilo Accesible',
                      description: 'Diseño optimizado para accesibilidad',
                      icon: Icons.accessibility_new,
                      color: const Color(0xFF388E3C),
                      onTap: () => _navigateToStyle(context, 2),
                    ),
                    _buildStyleCard(
                      context,
                      title: 'Estilo Moderno',
                      description: 'Diseño en cuadrícula moderna',
                      icon: Icons.grid_view,
                      color: const Color(0xFF7B1FA2),
                      onTap: () => _navigateToStyle(context, 3),
                    ),
                    _buildStyleCard(
                      context,
                      title: 'Estilo Simple',
                      description: 'Diseño simplificado con texto grande',
                      icon: Icons.format_size,
                      color: const Color(0xFFD32F2F),
                      onTap: () => _navigateToStyle(context, 4),
                    ),
                    _buildStyleCard(
                      context,
                      title: 'Estilo Barra de Navegación',
                      description: 'Interfaz con navegación por pestañas',
                      icon: Icons.tab,
                      color: const Color(0xFFFF7043),
                      onTap: () => _navigateToStyle(context, 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStyle(BuildContext context, int styleNumber) {
    Widget destination;
    
    switch (styleNumber) {
      case 1:
        destination = HomeStyle1(onThemeToggle: onThemeToggle);
        break;
      case 2:
        destination = HomeStyle2(onThemeToggle: onThemeToggle);
        break;
      case 3:
        destination = HomeStyle3(onThemeToggle: onThemeToggle);
        break;
      case 4:
        destination = HomeStyle4(onThemeToggle: onThemeToggle);
        break;
      case 5:
        destination = HomeStyle5(onThemeToggle: onThemeToggle);
        break;
      default:
        return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => destination),
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
                  builder: (context) => LoginScreen(onThemeToggle: onThemeToggle),
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