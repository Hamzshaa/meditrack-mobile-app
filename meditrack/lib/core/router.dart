import 'package:meditrack/presentation/screens/error_screen.dart';
import 'package:go_router/go_router.dart';

// Auth & Core
import 'package:meditrack/presentation/screens/login_page.dart';
import 'package:meditrack/presentation/screens/home_page.dart';
import 'package:meditrack/presentation/screens/pharmacy_overview_page.dart';

// Profile
import 'package:meditrack/presentation/screens/profile/profile_page.dart';
import 'package:meditrack/presentation/screens/profile/edit_profile_page.dart';
import 'package:meditrack/presentation/screens/profile/change_password_page.dart';

// Admin Overview Page
import 'package:meditrack/presentation/screens/admin_overview_page.dart';

// Pharmacy
import 'package:meditrack/presentation/screens/pharmacy/pharmacy_list_page.dart';
import 'package:meditrack/presentation/screens/pharmacy/pharmacy_page.dart';
import 'package:meditrack/presentation/screens/pharmacy/pharmacy_form_page.dart';

// Pharmacy Dashboard Medication Page
import 'package:meditrack/presentation/screens/medication_management_page.dart';

// Pharmacy Dashboard Inventory Page
import 'package:meditrack/presentation/screens/inventory_page.dart';

// --- Models ---
import 'package:meditrack/models/pharmacy.dart';
import 'package:meditrack/presentation/screens/setting_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  routes: [
    // --- Core Routes ---
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/settings",
      builder: (context, state) => const SettingsPage(),
    ),

    // --- Profile Routes ---
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: 'change-password',
          builder: (context, state) => const ChangePasswordPage(),
        ),
      ],
    ),

    // --- Admin Dashboard Overview ---
    GoRoute(
      path: '/admin/overview',
      name: 'adminOverview',
      builder: (context, state) => const AdminOverviewPage(),
      redirect: (context, state) async {
        return null;
      },
    ),

    // --- Admin Pharmacy Routes ---

    GoRoute(
      path: '/admin/pharmacies',
      builder: (context, state) => const PharmacyListPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const PharmacyFormPage(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final pharmacyId = int.tryParse(state.pathParameters['id'] ?? '');
            if (pharmacyId == null) {
              return const ErrorScreen(message: "Invalid Pharmacy ID format.");
            }
            return PharmacyPage(pharmacyId: pharmacyId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final pharmacyIdParam =
                    int.tryParse(state.pathParameters['id'] ?? '');
                if (pharmacyIdParam == null) {
                  return const ErrorScreen(
                      message: "Invalid Pharmacy ID format for edit.");
                }

                final pharmacy = state.extra as Pharmacy?;

                if (pharmacy == null) {
                  return ErrorScreen(
                    message:
                        "Error: Pharmacy object not passed via 'extra' for edit route ${state.uri.toString()}. Please navigate back and try again.",
                  );
                }

                if (pharmacy.pharmacyId != pharmacyIdParam) {
                  return ErrorScreen(
                    message:
                        "Error: Pharmacy ID mismatch. Path: $pharmacyIdParam, Extra: ${pharmacy.pharmacyId}",
                  );
                }

                return PharmacyFormPage(pharmacy: pharmacy);
              },
            ),
          ],
        ),
      ],
    ),

    // --- Admin Dashboard Overview ---
    GoRoute(
      path: '/pharmacy/overview',
      name: 'pharmacyOverview',
      builder: (context, state) => const PharmacyOverviewPage(),
      redirect: (context, state) async {
        return null;
      },
    ),

    // --- Pharmacy Dashboard medication page ---
    GoRoute(
      path: '/pharmacy/medications',
      name: 'pharmacyMedications',
      builder: (context, state) => const MedicationManagementPage(),
      redirect: (context, state) async {
        return null;
      },
    ),

    // --- Pharmacy Dashboard medication page ---
    GoRoute(
      path: '/pharmacy/inventory',
      name: 'pharmacyInventory',
      builder: (context, state) => const InventoryPage(),
      redirect: (context, state) async {
        return null;
      },
    ),
  ],
);
