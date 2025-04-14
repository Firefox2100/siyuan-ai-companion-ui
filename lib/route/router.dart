import 'package:auto_route/auto_route.dart';

import 'package:siyuan_ai_companion_ui/route/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      path: '/chat',
      initial: true,
      page: ChatRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: Duration(
        milliseconds: 200,
      ),
      reverseDuration: Duration(
        milliseconds: 200,
      ),
    ),
    CustomRoute(
      path: '/setting',
      page: SettingRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: Duration(
        milliseconds: 200,
      ),
      reverseDuration: Duration(
        milliseconds: 200,
      ),
    ),
  ];
}
