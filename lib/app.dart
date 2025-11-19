import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_client.dart';
import 'core/config/app_router.dart';
import 'core/storage/session_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/scan/data/repositories/trolley_repository_impl.dart';
import 'features/scan/domain/repositories/trolley_repository.dart';
import 'features/scan/presentation/bloc/scan_bloc.dart';

class InOutTrolleyApp extends StatelessWidget {
  const InOutTrolleyApp({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();
    final sessionStorage = SessionStorage(preferences);
    final savedUser = sessionStorage.readUser();
    final apiClient = ApiClient()..configure(token: savedUser?.token);

    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSource(apiClient),
      sessionStorage,
    );
    final trolleyRepository = TrolleyRepositoryImpl(apiClient);

    final app = MaterialApp(
      title: 'In-Out Trolley Mobile',
      theme: AppTheme.dark.copyWith(
        appBarTheme: AppTheme.dark.appBarTheme.copyWith(
          centerTitle: true,
          titleTextStyle: AppTheme.dark.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          iconTheme: AppTheme.dark.iconTheme,
          backgroundColor: AppTheme.dark.colorScheme.surface,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: AppRouter.login,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: apiClient),
        RepositoryProvider<SessionStorage>.value(value: sessionStorage),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<TrolleyRepository>.value(value: trolleyRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository)..checkSession(),
          ),
          BlocProvider<ScanBloc>(
            create: (context) =>
                ScanBloc(trolleyRepository, sessionStorage)..restoreSession(),
          ),
        ],
        child: app,
      ),
    );
  }
}
