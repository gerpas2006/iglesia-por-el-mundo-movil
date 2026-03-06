/// Guía de uso del sistema de manejo de excepciones

## 📋 Resumen

Se ha implementado un sistema centralizado de manejo de excepciones para toda la aplicación:

### 1. **Excepciones Personalizadas** (`lib/core/exceptions/app_exceptions.dart`)
- `NotFoundException` (404) - Recurso no encontrado
- `ValidationException` (422) - Error de validación
- `AuthenticationException` (401) - No autenticado
- `AuthorizationException` (403) - No autorizado
- `RouteNotFoundException` (404) - Ruta no encontrada
- `MethodNotAllowedException` (405) - Método no permitido
- `DatabaseException` (500) - Error de BD
- `ServerException` (500) - Error del servidor
- `NetworkException` (0) - Error de red
- `TimeoutException` (408) - Timeout
- `UnknownException` (500) - Error desconocido

### 2. **Manejador Centralizado** (`lib/core/service/error_handler.dart`)
- Convierte errores HTTP en excepciones personalizadas
- Maneja timeouts y errores de conexión automáticamente
- Proporciona mensajes amigables para el usuario

### 3. **Todos los Services Actualizados**
- EventosService
- LoginService
- CitasService
- DonacionesService
- OracionesService
- ReseneaService
- RegistreService

---

## 🚀 Cómo Usar en tus Widgets

### Ejemplo 1: En un BLoC o Provider

```dart
import 'package:iglesia_por_el_mundo_movil/core/exceptions/app_exceptions.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/eventos_service.dart';

class EventoProvider extends ChangeNotifier {
  final EventosService _service = EventosService();
  List<EventoResponse> eventos = [];
  AppException? error;

  Future<void> cargarEventos() async {
    try {
      error = null;
      eventos = await _service.getAllEventos();
      notifyListeners();
    } on NotFoundException catch (e) {
      error = e;
      notifyListeners();
    } on AuthenticationException catch (e) {
      error = e;
      notifyListeners();
    } on NetworkException catch (e) {
      error = e;
      notifyListeners();
    } on AppException catch (e) {
      error = e;
      notifyListeners();
    }
  }
}
```

### Ejemplo 2: En un Widget/Screen

```dart
class EventosScreen extends StatefulWidget {
  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  Future<void> _cargarEventos() async {
    try {
      final eventos = await EventosService().getAllEventos();
      // Usar los eventos
    } on AuthenticationException {
      _mostrarError('Debes autenticarte para ver los eventos');
      // Navegar a login
    } on NetworkException {
      _mostrarError('Verifica tu conexión a internet');
    } on TimeoutException {
      _mostrarError('La solicitud tardó demasiado tiempo');
    } on AppException catch (e) {
      _mostrarError(e.message);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tu UI aquí
  }
}
```

### Ejemplo 3: Manejo Granular

```dart
Future<void> crearDonacion(DonacionesDto donacion) async {
  try {
    final result = await DonacionesService().crearDonacion(donacion);
    mostrarExito('Donación creada exitosamente');
  } on ValidationException catch (e) {
    // Mostrar errores de validación específicos
    mostrarError('Error de validación: ${e.message}');
  } on AuthorizationException {
    mostrarError('No tienes permisos para realizar esta acción');
  } on DatabaseException {
    mostrarError('Error temporal con la base de datos. Intenta más tarde');
  } on ServerException catch (e) {
    mostrarError('Error del servidor: ${e.message}');
  } on NetworkException {
    mostrarError('Problemas de conexión. Verifica tu internet');
  } on AppException catch (e) {
    mostrarError(e.message);
  }
}
```

---

## 📊 Características Principales

✅ **Manejo automático de timeouts** - 30 segundos por defecto
✅ **Códigos de estado HTTP mapeados** - Excepciones específicas por tipo de error
✅ **Errores de red detectados** - Manejo de conexión, socket exceptions
✅ **Mensajes en español** - Todos los mensajes son amigables
✅ **Fácil de extender** - Puedes crear nuevas excepciones personalizadas
✅ **Type-safety** - Sistema de tipos robusto

---

## 🔧 Extender con Nuevas Excepciones

Si necesitas una excepción personalizada:

```dart
// En lib/core/exceptions/app_exceptions.dart

class CustomException extends AppException {
  CustomException({
    String message = 'Error personalizado',
    String? errorCode,
  }) : super(
    message: message,
    statusCode: 400,
    errorCode: errorCode,
  );
}

// Uso en un service
try {
  // Código aquí
} catch (e) {
  throw CustomException(message: 'Tu mensaje personalizado');
}
```

---

## 📌 Notas Importantes

1. **Siempre captura `AppException`** como la última línea de defensa
2. **Los timeouts se configuran en 30 segundos** - Ajustable si lo necesitas
3. **Todos los services lanzan excepciones type-safe** - No hay `Exception` genéricas
4. **El ErrorHandler maneja conversiones** - No necesitas hacer try-catch complejos
5. **Los mensajes ya están localizados en español** - Listos para mostrar al usuario

---

## 🎯 Ventajas de este Sistema

- **Consistencia**: Todos los services manejan errores igual
- **Rastreabilidad**: Puedes saber exactamente qué tipo de error ocurrió
- **UX Mejorada**: Mensajes claros y específicos para cada situación
- **Debugging**: Código de estado y error codes para logs
- **Mantenibilidad**: Fácil de actualizar mensajes globalmente

¡Tu aplicación está lista para manejar todas las excepciones correctamente! 🎉
