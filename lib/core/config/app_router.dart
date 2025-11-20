import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/scan/presentation/scan_page.dart';
import '../../features/scan/presentation/scan_summary_page.dart';
import '../storage/session_storage.dart';
import '../../features/home/presentation/cubit/departure_history_cubit.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String scanSummary = '/scan/summary';
  static const String history = '/history';

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute<void>(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case scan:
        return MaterialPageRoute<void>(
          builder: (_) => const ScanPage(),
          settings: settings,
        );
      case scanSummary:
        return MaterialPageRoute<void>(
          builder: (_) => const ScanSummaryPage(),
          settings: settings,
        );
      case history:
        return MaterialPageRoute<void>(
          builder: (context) => BlocProvider<DepartureHistoryCubit>(
            create: (_) => DepartureHistoryCubit(
              context.read<SessionStorage>(),
            )..loadHistory(),
            child: const HistoryPage(),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
    }
  }
}
