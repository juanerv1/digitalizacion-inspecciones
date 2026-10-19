import 'package:inspecciones_llantas/core/network/api_client.dart';
import 'package:inspecciones_llantas/services/service_locator.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_clientes.dart';
import 'package:inspecciones_llantas/ui/Views/pantalla_inspecciones_pendientes.dart';
import 'package:inspecciones_llantas/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  
  // Si hay algo guardado, sobreescribe el default de ApiConfig. Si no, deja el default.
  ApiConfig.baseUrl = prefs.getString('baseUrl') ?? ApiConfig.baseUrl;
  ApiConfig.apiKey = prefs.getString('apiKey') ?? ApiConfig.apiKey;

  setupLocator();

  runApp(const MiAppInspecciones());
}

ThemeData _construirTema() {
  final bordeSuave = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.border),
  );
  final formaBoton = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.border,

    // Barra superior clara, igual que el navbar del frontend web
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.border,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    // Tarjetas blancas con borde fino y sombra suave
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: bordeSuave,
      enabledBorder: bordeSuave,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.grey),
      prefixIconColor: AppColors.grey,
    ),

    // Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: formaBoton,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: formaBoton,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.greyLight),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: formaBoton,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),

    // Chips (filtros)
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryTint,
      side: const BorderSide(color: AppColors.border),
      labelStyle: const TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.w500),
      secondaryLabelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
      checkmarkColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Diálogos, menús y avisos
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      titleTextStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),

    // Navegación inferior clara con indicador azul suave
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      indicatorColor: AppColors.primaryTint,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected) ? AppColors.primary : AppColors.grey,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final seleccionado = states.contains(WidgetState.selected);
        return TextStyle(
          color: seleccionado ? AppColors.primary : AppColors.grey,
          fontWeight: seleccionado ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        );
      }),
    ),
  );
}

class MiAppInspecciones extends StatelessWidget {
  const MiAppInspecciones({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Inspecciones',
      theme: _construirTema(),
      home: const NavegacionPrincipal(),
      locale: const Locale('es', 'ES'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés (opcional)
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavegacionPrincipal extends StatefulWidget {
  const NavegacionPrincipal({super.key});

  @override
  State<NavegacionPrincipal> createState() => _NavegacionPrincipalState();
}

class _NavegacionPrincipalState extends State<NavegacionPrincipal> {
  int _indiceActual = 0;
  
  // 1. Declaramos el controlador
  late PageController _pageController;

  final List<Widget> pantallas = const [
    PantallaInspecciones(),
    PantallaClientes(),
  ];

  @override
  void initState() {
    super.initState();
    // 2. Inicializamos el controlador apuntando a la pestaña inicial
    _pageController = PageController(initialPage: _indiceActual);
  }

  @override
  void dispose() {
    // 3. Importante: liberar el controlador de la memoria al cerrar la vista
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 4. Reemplazamos el array directo por un PageView
      body: PageView(
        controller: _pageController,
        // physics: Evita que el usuario cambie de pestaña deslizando el dedo por la pantalla.
        // Se recomienda ponerlo en NeverScrollableScrollPhysics para que no haga conflicto 
        // con otros elementos deslizables dentro de tus pantallas (como borrar items).
        physics: const NeverScrollableScrollPhysics(),
        children: pantallas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual,
        surfaceTintColor: Colors.transparent, 
        onDestinationSelected: (int indice) {
          setState(() {
            _indiceActual = indice;
          });
          // 5. En lugar de solo cambiar el estado, animamos el cambio de página
          _pageController.animateToPage(
            indice,
            duration: const Duration(milliseconds: 300), // Velocidad de la animación
            curve: Curves.easeInOut, // Curva de suavizado
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Pendientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Clientes',
          ),
        ],
      ),
    );
  }
}