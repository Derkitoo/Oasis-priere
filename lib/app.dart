import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/user_provider.dart';
import 'core/providers/progress_provider.dart';
import 'core/providers/prayer_provider.dart';
import 'core/services/database_service.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

class OasisPriereApp extends StatelessWidget {
  const OasisPriereApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<DatabaseService>(create: (_) => DatabaseService()),
          ChangeNotifierProxyProvider<DatabaseService, UserProvider>(
            create: (ctx) => UserProvider(ctx.read<DatabaseService>()),
            update: (_, db, prev) => prev ?? UserProvider(db),
          ),
          ChangeNotifierProxyProvider<DatabaseService, ProgressProvider>(
            create: (ctx) => ProgressProvider(ctx.read<DatabaseService>()),
            update: (_, db, prev) => prev ?? ProgressProvider(db),
          ),
          ChangeNotifierProvider<PrayerProvider>(create: (_) => PrayerProvider()),
        ],
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            // Thème auto basé sur l'heure (Mode sombre : Maghreb + Isha)
            final now = DateTime.now();
            final isNight = now.hour >= 19 || now.hour < 5;
            final themePref = userProvider.user?.themePreference ?? 'auto';
            final brightness = switch (themePref) {
              'dark' => Brightness.dark,
              'light' => Brightness.light,
              _ => isNight ? Brightness.dark : Brightness.light,
            };

            return MaterialApp(
              title: "L'Oasis de la Prière",
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
              home: _RootNavigator(),
            );
          },
        ),
      );
}

class _RootNavigator extends StatefulWidget {
  @override
  State<_RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<_RootNavigator> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    await context.read<UserProvider>().init();
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return _Splash();
    final userProvider = context.watch<UserProvider>();
    if (userProvider.isLoading) return _Splash();
    if (!userProvider.onboardingComplete || !userProvider.isLoggedIn) {
      return const WelcomeScreen();
    }
    return const DashboardScreen();
  }
}

class _Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bgCard,
                  border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 2),
                ),
                child: const Center(child: Text('🕌', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 16),
              const Text("L'Oasis de la Prière", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.goldLight)),
              const SizedBox(height: 24),
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2)),
            ],
          ),
        ),
      );
}
