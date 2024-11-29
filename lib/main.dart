import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:lulu/config/routes.dart';
import 'package:lulu/config/theme.dart';
import 'package:lulu/providers/product_provider.dart';
import 'package:lulu/providers/invoice_provider.dart';
import 'package:lulu/providers/printer_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Add configuration validation
    final firebaseOptions = await getFirebaseOptions(); // Create this method
    await Firebase.initializeApp(options: firebaseOptions);

    // Add error reporting
    setupErrorReporting(); // Create this method

    runApp(const MyApp());
  } catch (error, stackTrace) {
    // Log error to crash reporting service
    await reportError(error, stackTrace);

    // Show error UI
    runApp(ErrorApp(error: error)); // Create this widget
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => PrinterProvider()),
      ],
      child: MaterialApp(
        title: 'Lulu Enterprises',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark, // Add dark theme
        themeMode: ThemeMode.system, // Respect system theme
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.home,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => NotFoundScreen(), // Create this widget
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
