// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:siyuan_ai_companion_ui/page/chat.dart' as _i1;
import 'package:siyuan_ai_companion_ui/page/setting.dart' as _i2;

/// generated route for
/// [_i1.ChatPage]
class ChatRoute extends _i3.PageRouteInfo<void> {
  const ChatRoute({List<_i3.PageRouteInfo>? children})
    : super(ChatRoute.name, initialChildren: children);

  static const String name = 'ChatRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.ChatPage();
    },
  );
}

/// generated route for
/// [_i2.SettingPage]
class SettingRoute extends _i3.PageRouteInfo<void> {
  const SettingRoute({List<_i3.PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.SettingPage();
    },
  );
}
