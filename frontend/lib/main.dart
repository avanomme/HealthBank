// Created with the Assistance of Claude Code and Codex
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/api/api_client.dart';
import 'src/core/theme/chrome_style_provider.dart';
import 'src/core/theme/theme.dart';
import 'src/config/go_router.dart';
import 'src/core/l10n/generated/app_localizations.dart';
import 'src/core/l10n/page_language_sync.dart';
import 'src/core/state/locale_provider.dart';
import 'src/core/widgets/basics/maintenance_banner.dart';
import 'src/features/admin/widgets/widgets.dart';
import 'src/features/auth/auth_state.dart';
import 'src/features/auth/widgets/session_expiry_monitor.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));

}

/// Provider to track if session has been initialized
final sessionInitializedProvider = StateProvider<bool>((ref) => false);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _mobileAuthInstalled = false;
  String? _syncedPageLanguageTag;

  @override
  void initState() {
    super.initState();
    // Wire up the 401 session-expired handler
    ApiClient.onSessionExpired = _handleSessionExpired;
    // Restore session on app startup
    _initializeSession();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Install mobile Bearer token interceptor after widget tree is mounted.
    // No-op on web — cookies handle auth there.
    if (!_mobileAuthInstalled) {
      _mobileAuthInstalled = true;
      ApiClient.installMobileAuth(ref);
    }
  }

  /// Called by [_ErrorInterceptor] when a 401 is received.
  /// Resets auth state; the GoRouter redirect (via [authChangeNotifier])
  /// will navigate to the login page.
  void _handleSessionExpired() {
    final ready = ref.read(sessionInitializedProvider);
    if (!ready) return; // ignore startup 401s
    ref.read(authProvider.notifier).reset();
  }

  Future<void> _initializeSession() async {
    // Don't re-initialize if already done
    if (ref.read(sessionInitializedProvider)) return;

    String? role;
    try {
      // Restore session by calling /sessions/me — returns role if session valid
      role = await ref.read(authProvider.notifier).restoreSession();
    } catch (_) {
      // Session restoration failed - that's ok, user will need to login
    } finally {
      ref.read(sessionInitializedProvider.notifier).state = true;
      // Push restored role into the GoRouter guard immediately
      authChangeNotifier.update(
        isAuthenticated: ref.read(authProvider).isAuthenticated,
        sessionReady: true,
        role: role,
        mustChangePassword: ref.read(authProvider).mustChangePassword,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final appearance = ref.watch(appAppearanceProvider);
    final sessionReady = ref.watch(sessionInitializedProvider);
    final authState = ref.watch(authProvider);
    final pageLanguageTag = pageLanguageTagForLocale(locale);

    if (_syncedPageLanguageTag != pageLanguageTag) {
      _syncedPageLanguageTag = pageLanguageTag;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        syncPageLanguageForLocale(locale);
      });
    }

    AppTheme.setAppearance(appearance);

    // Bridge Riverpod auth state → GoRouter's AuthChangeNotifier.
    // ref.listen callbacks fire after the build, avoiding setState-during-build.
    ref.listen(authProvider, (_, auth) {
      authChangeNotifier.update(
        isAuthenticated: auth.isAuthenticated,
        sessionReady: ref.read(sessionInitializedProvider),
        role: auth.user?.role,
        mustChangePassword: auth.mustChangePassword,
      );
      ref.read(appAppearanceProvider.notifier).syncForCurrentUser();
    });
    ref.listen(sessionInitializedProvider, (_, ready) {
      authChangeNotifier.update(
        isAuthenticated: ref.read(authProvider).isAuthenticated,
        sessionReady: ready,
        role: ref.read(authProvider).user?.role,
        mustChangePassword: ref.read(authProvider).mustChangePassword,
      );
    });

    // Eagerly sync the current values (covers the initial build).
    // AuthChangeNotifier.update is a no-op when values haven't changed.
    authChangeNotifier.update(
      isAuthenticated: authState.isAuthenticated,
      sessionReady: sessionReady,
      role: authState.user?.role,
      mustChangePassword: authState.mustChangePassword,
    );

    // this ended up resetting the route so commented out. functionality remains in the layoutbuilder
    // will remove if routing bug is fixed by this change
    // Gate the app on session initialisation — show a loading spinner
    // until the stored session token has been restored (or determined absent).
    /*
    if (!sessionReady) {
      return MaterialApp(
        title: 'HealthBank',
        theme: ThemeData.light(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    */

    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);

        return MaterialApp.router(
          title: 'HealthBank',
          theme: AppTheme.themeForBreakpoint(
            breakpoint,
            mode: AppThemeMode.light,
          ),
          darkTheme: AppTheme.themeForBreakpoint(
            breakpoint,
            mode: AppThemeMode.dark,
          ),
          themeMode: appearance.themeMode == AppThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: appRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          builder: (context, child) {
            // Wrap all pages with impersonation banner (your existing shell)
            final app = _RouteTitleScope(
              child: _AppShell(child: child ?? const SizedBox.shrink()),
            );

            // While session is initializing, DO NOT replace the app.
            // Just block interaction / show spinner on top.
            if (!sessionReady) {
              return Stack(
                children: [
                  app,
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              );
            }

            return app;
          },
        );
      },
    );
  }
}

/// App shell that wraps all pages with the impersonation banner
///
/// The banner appears at the top when an admin is impersonating a user.
/// It automatically hides when not impersonating.
class _AppShell extends ConsumerWidget {
  const _AppShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impersonationState = ref.watch(impersonationProvider);
    final isFullUser = impersonationState.isFullUser;
    final isAdmin = ref.watch(isSystemAdminProvider);
    final showAdminBanner = impersonationState.isRolePreview && isAdmin;

    final body = SafeArea(
      bottom: false, // Individual pages handle bottom safe area
      child: Column(
        children: [
          // Admin view-as banner (role preview mode only)
          if (showAdminBanner) const AdminViewAsBanner(),

          // Animated impersonation banner (full user mode only)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: isFullUser ? kImpersonationBannerHeight : 0,
            child: isFullUser
                ? const ImpersonationBanner()
                : const SizedBox.shrink(),
          ),

          // Global maintenance banner — shown on every page when active
          const MaintenanceBanner(),

          // Main content (all pages)
          Expanded(child: child),
        ],
      ),
    );

    // WCAG 2.2.1: Wrap with session expiry monitor so users are warned before
    // their session expires and given the option to extend or log out.
    final monitored = SessionExpiryMonitor(child: body);

    // On iOS the status-bar area is transparent and shows whatever is rendered
    // behind it. Wrap in a ColoredBox using the header chrome colour so the
    // status bar blends into the header chrome.
    if (!kIsWeb && Platform.isIOS) {
      return ColoredBox(color: AppTheme.backgroundChrome, child: monitored);
    }
    // On Android the system status bar sits above the AppBar. Make it
    // transparent and paint the AppBar's primary colour behind it so the status
    // bar blends seamlessly into the header.
    if (!kIsWeb && Platform.isAndroid) {
      // AppBar background is AppTheme.primary — always a dark navy, so icons
      // should be light (white).
      const iconBrightness = Brightness.light;
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: iconBrightness,
        ),
        child: ColoredBox(color: AppTheme.primary, child: monitored),
      );
    }
    return monitored;
  }
}

class _RouteTitleScope extends StatelessWidget {
  const _RouteTitleScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appRouter.routerDelegate,
      builder: (context, _) {
        return Title(
          title: routeTitleForUri(
            appRouter.routerDelegate.currentConfiguration.uri,
          ),
          color: AppTheme.primary,
          child: child,
        );
      },
    );
  }
}
