import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/ui/resources/app_theme.dart';
import 'core/ui/screens/splash_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString(
      'assets/fonts/Noto_Sans/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(<String>['Noto_Sans'], license);
  });

  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = setupServiceLocator();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _AppShell(
            home: SplashScreen(status: SplashStatus.error),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const _AppShell(home: SplashScreen());
        }

        return const MainApp();
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plata Sync',
      onGenerateTitle: (context) => AppL10n.of(context).appTitle,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}

class _AppShell extends StatelessWidget {
  final Widget home;

  const _AppShell({required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plata Sync',
      onGenerateTitle: (context) => AppL10n.of(context).appTitle,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: home,
    );
  }
}
