// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [HistoryPage]
class HistoryRoute extends PageRouteInfo<HistoryRouteArgs> {
  HistoryRoute({
    Key? key,
    dynamic Function(int, {int? sessionId})? onTabChange,
    List<PageRouteInfo>? children,
  }) : super(
         HistoryRoute.name,
         args: HistoryRouteArgs(key: key, onTabChange: onTabChange),
         initialChildren: children,
       );

  static const String name = 'HistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HistoryRouteArgs>(
        orElse: () => const HistoryRouteArgs(),
      );
      return HistoryPage(key: args.key, onTabChange: args.onTabChange);
    },
  );
}

class HistoryRouteArgs {
  const HistoryRouteArgs({this.key, this.onTabChange});

  final Key? key;

  final dynamic Function(int, {int? sessionId})? onTabChange;

  @override
  String toString() {
    return 'HistoryRouteArgs{key: $key, onTabChange: $onTabChange}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HistoryRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    dynamic Function(int)? onTabChange,
    List<PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, onTabChange: onTabChange),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return HomePage(key: args.key, onTabChange: args.onTabChange);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.onTabChange});

  final Key? key;

  final dynamic Function(int)? onTabChange;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, onTabChange: $onTabChange}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HomeRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [InteractiveStudioPage]
class InteractiveStudioRoute extends PageRouteInfo<InteractiveStudioRouteArgs> {
  InteractiveStudioRoute({
    Key? key,
    Question? initialQuestion,
    List<PageRouteInfo>? children,
  }) : super(
         InteractiveStudioRoute.name,
         args: InteractiveStudioRouteArgs(
           key: key,
           initialQuestion: initialQuestion,
         ),
         initialChildren: children,
       );

  static const String name = 'InteractiveStudioRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InteractiveStudioRouteArgs>(
        orElse: () => const InteractiveStudioRouteArgs(),
      );
      return InteractiveStudioPage(
        key: args.key,
        initialQuestion: args.initialQuestion,
      );
    },
  );
}

class InteractiveStudioRouteArgs {
  const InteractiveStudioRouteArgs({this.key, this.initialQuestion});

  final Key? key;

  final Question? initialQuestion;

  @override
  String toString() {
    return 'InteractiveStudioRouteArgs{key: $key, initialQuestion: $initialQuestion}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InteractiveStudioRouteArgs) return false;
    return key == other.key && initialQuestion == other.initialQuestion;
  }

  @override
  int get hashCode => key.hashCode ^ initialQuestion.hashCode;
}

/// generated route for
/// [MainLayoutPage]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
    : super(MainLayoutRoute.name, initialChildren: children);

  static const String name = 'MainLayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainLayoutPage();
    },
  );
}

/// generated route for
/// [PdfWorkspacePage]
class PdfWorkspaceRoute extends PageRouteInfo<PdfWorkspaceRouteArgs> {
  PdfWorkspaceRoute({Key? key, int? sessionId, List<PageRouteInfo>? children})
    : super(
        PdfWorkspaceRoute.name,
        args: PdfWorkspaceRouteArgs(key: key, sessionId: sessionId),
        initialChildren: children,
      );

  static const String name = 'PdfWorkspaceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PdfWorkspaceRouteArgs>(
        orElse: () => const PdfWorkspaceRouteArgs(),
      );
      return PdfWorkspacePage(key: args.key, sessionId: args.sessionId);
    },
  );
}

class PdfWorkspaceRouteArgs {
  const PdfWorkspaceRouteArgs({this.key, this.sessionId});

  final Key? key;

  final int? sessionId;

  @override
  String toString() {
    return 'PdfWorkspaceRouteArgs{key: $key, sessionId: $sessionId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PdfWorkspaceRouteArgs) return false;
    return key == other.key && sessionId == other.sessionId;
  }

  @override
  int get hashCode => key.hashCode ^ sessionId.hashCode;
}

/// generated route for
/// [PlaceholderPage]
class PlaceholderRoute extends PageRouteInfo<PlaceholderRouteArgs> {
  PlaceholderRoute({
    Key? key,
    String title = 'Placeholder',
    List<PageRouteInfo>? children,
  }) : super(
         PlaceholderRoute.name,
         args: PlaceholderRouteArgs(key: key, title: title),
         initialChildren: children,
       );

  static const String name = 'PlaceholderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlaceholderRouteArgs>(
        orElse: () => const PlaceholderRouteArgs(),
      );
      return PlaceholderPage(key: args.key, title: args.title);
    },
  );
}

class PlaceholderRouteArgs {
  const PlaceholderRouteArgs({this.key, this.title = 'Placeholder'});

  final Key? key;

  final String title;

  @override
  String toString() {
    return 'PlaceholderRouteArgs{key: $key, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlaceholderRouteArgs) return false;
    return key == other.key && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode;
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [SimilarQuestionsPage]
class SimilarQuestionsRoute extends PageRouteInfo<SimilarQuestionsRouteArgs> {
  SimilarQuestionsRoute({
    Key? key,
    Question? originalQuestion,
    List<PageRouteInfo>? children,
  }) : super(
         SimilarQuestionsRoute.name,
         args: SimilarQuestionsRouteArgs(
           key: key,
           originalQuestion: originalQuestion,
         ),
         initialChildren: children,
       );

  static const String name = 'SimilarQuestionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SimilarQuestionsRouteArgs>(
        orElse: () => const SimilarQuestionsRouteArgs(),
      );
      return SimilarQuestionsPage(
        key: args.key,
        originalQuestion: args.originalQuestion,
      );
    },
  );
}

class SimilarQuestionsRouteArgs {
  const SimilarQuestionsRouteArgs({this.key, this.originalQuestion});

  final Key? key;

  final Question? originalQuestion;

  @override
  String toString() {
    return 'SimilarQuestionsRouteArgs{key: $key, originalQuestion: $originalQuestion}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SimilarQuestionsRouteArgs) return false;
    return key == other.key && originalQuestion == other.originalQuestion;
  }

  @override
  int get hashCode => key.hashCode ^ originalQuestion.hashCode;
}
