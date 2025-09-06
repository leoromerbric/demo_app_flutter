# Mi Wallet & Production Management - Flutter Demo App

Una aplicación Flutter que incluye funcionalidades de cartera digital y gestión de producción con múltiples estilos de interfaz de usuario y enfoque en accesibilidad.

## Características

### Cartera Digital
- 🔐 Sistema de autenticación con credenciales de prueba
- 🎨 4 estilos diferentes de interfaz de usuario
- 🌙 Soporte para tema claro y oscuro
- ♿ Optimizada para accesibilidad
- 💳 Gestión de tarjetas y transacciones
- 📱 Material Design 3

### Gestión de Producción
- 🏭 Gestión de órdenes de trabajo
- ⚙️ Confirmación de operaciones
- 📦 Movimientos de materiales (egreso/devolución/recepción)
- 📊 Control de actividades y tarifas
- 🔍 Filtros avanzados de búsqueda
- ✅ Validaciones en línea

## Credenciales de Prueba

- **Usuario:** `leonel`
- **Contraseña:** `1234`

## Funcionalidades de Producción

### Flujo de 4 Pantallas

1. **Bandeja/Filtro**: Filtrado y listado de órdenes de trabajo
   - Filtros por pedido cliente, centro/planta, puesto de trabajo, fechas, estado
   - Lista de órdenes con información detallada y progreso

2. **Operaciones**: Lista de operaciones de una orden de trabajo
   - Información detallada de cada operación
   - Estado y progreso de confirmación
   - Navegación a confirmación

3. **Confirmación + Actividades**: Confirmación de operación con actividades
   - Captura de cantidades (buenas, rechazo, reproceso)
   - Gestión de actividades (MOD, indirectos, energía, depreciación)
   - Cálculo automático de costos

4. **Componentes**: Gestión de materiales y componentes
   - Lista de materiales sugeridos por BOM
   - Agregar/quitar materiales
   - Búsqueda por código/descripción
   - Selección de lotes y unidades de medida
   - Tipos de movimiento (consumo, devolución, recepción)

### Características Técnicas
- Valores por defecto configurables
- Validaciones de stock y lotes
- Interfaz optimizada para móvil
- Navegación tipo cards
- Búsquedas asistidas
- Totales fijos al pie

## Estilos de Interfaz

### 1. Estilo Clásico
Diseño tradicional con tarjetas deslizables y botones de acción rápida.

### 2. Estilo Accesible
Interfaz optimizada para accesibilidad con texto grande, alto contraste y navegación simplificada.

### 3. Estilo Moderno
Diseño con pestañas, cuadrícula de acciones y animaciones modernas.

### 4. Estilo Simple
Interfaz minimalista con texto extra grande y navegación por páginas.

## Tecnologías

- Flutter 3.24
- Dart 3.8
- Material Design 3

## Instalación

1. Clona el repositorio
2. Ejecuta `flutter pub get` para instalar dependencias
3. Ejecuta `flutter run` para iniciar la aplicación

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
├── screens/                  # Pantallas de la aplicación
│   ├── login_screen.dart     # Pantalla de inicio de sesión
│   ├── home_selector_screen.dart # Selector de estilos
│   └── home_styles/          # Diferentes estilos de inicio
├── services/                 # Servicios (autenticación, datos)
├── themes/                   # Configuración de temas
└── widgets/                  # Widgets reutilizables
```

## Funcionalidades

- ✅ Inicio de sesión con validación
- ✅ Selección de estilo de interfaz
- ✅ Visualización de saldo y tarjetas
- ✅ Historial de transacciones
- ✅ Cambio de tema (claro/oscuro)
- ✅ Navegación entre diferentes estilos
- ✅ Funciones de cartera (enviar, escanear, recargar)
- ✅ Accesibilidad mejorada

## Licencia

Este es un proyecto de demostración desarrollado para propósitos educativos y de prototipado.