import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_router.dart';
import '../../../core/theme/layout_constants.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          Navigator.of(context).pushReplacementNamed(AppRouter.home);
        } else if (state.status == AuthStatus.pendingApproval) {
          showDialog<void>(
            context: context,
            builder: (_) => const _PendingApprovalDialog(),
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? 'Login gagal')));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: LayoutConstants.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Login to Geum Cheon Trolly',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LoginTextField(
                    controller: _identityController,
                    label: 'Email atau Nomor Telepon',
                    icon: Icons.account_circle_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _LoginTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().login(
                              identity: _identityController.text.trim(),
                              password: _passwordController.text,
                            );
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login Securely'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: isLoading ? null : () {},
                    child: const Text('Use Saved Token'),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(
                              context,
                            ).pushNamed(AppRouter.register),
                      child: const Text('Buat akun baru'),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _PendingApprovalDialog extends StatelessWidget {
  const _PendingApprovalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Menunggu Persetujuan'),
      content: const Text(
        'Akun Anda masih menunggu approval admin. Kami akan memberi notifikasi setelah disetujui.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
