import 'package:flutter/material.dart';
import '../presentation/pc_streaming_setup/pc_streaming_setup.dart';
import '../presentation/game_library/game_library.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/controller_settings/controller_settings.dart';
import '../presentation/touch_controls_editor/touch_controls_editor.dart';
import '../presentation/performance_dashboard/performance_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String pcStreamingSetup = '/pc-streaming-setup';
  static const String gameLibrary = '/game-library';
  static const String login = '/login-screen';
  static const String controllerSettings = '/controller-settings';
  static const String touchControlsEditor = '/touch-controls-editor';
  static const String performanceDashboard = '/performance-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    pcStreamingSetup: (context) => const PcStreamingSetup(),
    gameLibrary: (context) => const GameLibrary(),
    login: (context) => const LoginScreen(),
    controllerSettings: (context) => const ControllerSettings(),
    touchControlsEditor: (context) => const TouchControlsEditor(),
    performanceDashboard: (context) => const PerformanceDashboard(),
    // TODO: Add your other routes here
  };
}
