import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ai_question_generator/core/di/injection.dart';
import 'package:ai_question_generator/core/theme/app_theme.dart';
import 'package:ai_question_generator/core/router/app_router.dart';
import 'package:ai_question_generator/shared/widgets/responsive_phone_frame.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'app_title'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _appRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return ResponsivePhoneFrame(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
