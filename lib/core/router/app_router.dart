import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/pdf_workspace/presentation/pages/pdf_workspace_page.dart';
import '../../features/similar_questions/presentation/pages/similar_questions_page.dart';
import '../../features/interactive_studio/presentation/pages/interactive_studio_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/pdf_workspace/domain/entities/question_entity.dart';
import '../../shared/widgets/main_layout.dart';
import '../../shared/pages/placeholder_page.dart';
part 'app_router.gr.dart';
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainLayoutRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: PdfWorkspaceRoute.page),
        AutoRoute(page: HistoryRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: SimilarQuestionsRoute.page),
    AutoRoute(page: InteractiveStudioRoute.page),
  ];
}
