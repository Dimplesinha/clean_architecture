import 'package:flutter/material.dart';
import 'package:workapp/src/presentation/style/theme/app_theme.dart';
import 'package:workapp/src/presentation/style/theme/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:workapp/src/core/core_exports.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/23
/// @Message : [AppView]
/// Root View of application that returns MaterialApp which allows configuration
/// on App Launch

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

/// [AppView]
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, ThemeNotifier themeNotifier, child) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          title: AppConstants.appTitleStr,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: themeNotifier.currentTheme == AppTheme.darkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
          onGenerateRoute: AppRouter.generateRoute,
          scaffoldMessengerKey: snackBarKey,
          builder: (context, child) {
            // Add MediaQuery to disable text scaling globally
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0), // Prevent text scaling based on system settings
              ),
              child: child!,
            );
          },
        ),
      );
    });
  }
}
