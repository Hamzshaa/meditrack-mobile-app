import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/models/user.dart';
import 'package:meditrack/providers/user_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final User? currentUser = ref.read(currentUserProvider);
    _firstNameController =
        TextEditingController(text: currentUser?.first_name ?? '');
    _lastNameController =
        TextEditingController(text: currentUser?.last_name ?? '');
    _phoneController = TextEditingController(text: currentUser?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitProfileUpdate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final profileData = {
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': ref.watch(currentUserProvider)?.email,
    };

    ref.read(profileUpdateProvider.notifier).updateUserProfile(
          profileData: profileData,
        );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green,
      ),
    );

    if (!isError) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          Navigator.maybePop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(profileUpdateProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous is AsyncLoading) {
            _showSnackbar('Profile updated successfully!');
          }
        },
        error: (error, stackTrace) {
          String displayError = error is AuthException
              ? error.message
              : error.toString().replaceFirst('Exception: ', '');
          _showSnackbar('Update failed: $displayError', isError: true);
        },
      );
    });

    final updateState = ref.watch(profileUpdateProvider);
    final isLoading = updateState.isLoading;

    final currentUserEmail = ref.watch(currentUserProvider)?.email ?? 'N/A';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (v) => v!.isEmpty ? 'Cannot be empty' : null,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (v) => v!.isEmpty ? 'Cannot be empty' : null,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: currentUserEmail,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    suffixIcon: Tooltip(
                      message: "Email cannot be changed here",
                      child: Icon(Icons.lock_outline,
                          size: 18, color: Colors.grey),
                    )),
                readOnly: true,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'Phone (Optional)'),
                keyboardType: TextInputType.phone,
                enabled: !isLoading,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) =>
                    isLoading ? null : _submitProfileUpdate(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isLoading ? null : _submitProfileUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
