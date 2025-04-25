import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/models/user.dart';
import 'package:meditrack/presentation/widgets/meditrack_logo.dart';
import 'package:meditrack/presentation/widgets/shared/theme_toggle_button.dart';
import 'package:meditrack/providers/auth_provider.dart';
import 'package:meditrack/providers/user_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      ref.read(authNotifierProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String?>>(authNotifierProvider, (previous, next) {
      if (!next.isLoading && next.hasError) {
        if (!mounted) return;

        String errorMessage = "Login failed. Please try again.";

        final error = next.error;
        if (error is Exception) {
          final message = error.toString();
          if (message.contains("Invalid credentials")) {
            errorMessage = "Invalid credentials.";
          } else if (message.startsWith("Exception: ")) {
            errorMessage = message.substring("Exception: ".length);
          } else {
            errorMessage = message;
          }
        }
        _showErrorSnackbar(errorMessage);
      }
    });

    ref.listen<AsyncValue<User?>>(currentUserNotifierProvider,
        (previous, next) {
      if (next.hasValue && next.value != null) {
        if (mounted) {
          context.go("/");
        } else if (mounted) {}
      }
    });

    final loginActionState = ref.watch(authNotifierProvider);
    final isLoading = loginActionState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 16.0),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MediTrackLogo(),
              const SizedBox(height: 40),
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ), // Rounded corners
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome Back',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          enabled: !isLoading,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          enabled: !isLoading,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              isLoading ? null : _submitForm(),
                        ),
                        // const SizedBox(height: 8),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: isLoading
                        //         ? null
                        //         : () => context.go('/forgot-password'),
                        //     child: const Text('Forgot Password?'),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                            onPressed: isLoading ? null : _submitForm,
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Don't have an account?",
              //       style: Theme.of(context).textTheme.bodyMedium,
              //     ),
              //     TextButton(
              //       onPressed: isLoading ? null : () => context.go('/register'),
              //       child: const Text('Sign Up'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
