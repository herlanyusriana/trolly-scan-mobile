import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_router.dart';
import '../../auth/domain/entities/mobile_user.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo_gci.png',
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text('Geum Cheon Trolly'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState.user;
          final displayName = _resolveDisplayName(user);
          final shiftLabel = _resolveShiftLabel(user);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $displayName',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  shiftLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRouter.scan),
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan Trolley'),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRouter.history),
                  icon: const Icon(Icons.history_rounded),
                  label: const Text('History'),
                ),
                const SizedBox(height: 24),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Surat jalan akan tersedia setelah submit',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _resolveDisplayName(MobileUser? user) {
    final name = user?.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    final phone = user?.phone?.trim();
    if (phone != null && phone.isNotEmpty) return phone;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) return email;
    return 'Operator';
  }

  static String _resolveShiftLabel(MobileUser? user) {
    final shift = user?.shift?.trim();
    if (shift != null && shift.isNotEmpty) {
      return 'Shift Aktif: $shift';
    }

    final now = DateTime.now().hour;
    if (now >= 6 && now < 14) {
      return 'Shift Aktif: Pagi (06:00 - 14:00)';
    }
    if (now >= 14 && now < 22) {
      return 'Shift Aktif: Sore (14:00 - 22:00)';
    }
    return 'Shift Aktif: Malam (22:00 - 06:00)';
  }
}
