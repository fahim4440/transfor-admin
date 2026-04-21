import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfor_admin_dashboard/screens/dashboard_screen/dashboard_screen.dart';
import 'package:transfor_admin_dashboard/screens/login_screen/login_screen.dart';
import 'package:transfor_admin_dashboard/screens/main_layout.dart';
import 'package:transfor_admin_dashboard/screens/orders_screen/orders_screen.dart';
import 'package:transfor_admin_dashboard/screens/payout_history_screen/payout_history_screen.dart';
import 'package:transfor_admin_dashboard/screens/payout_request_screen/payout_request_screen.dart';
import 'package:transfor_admin_dashboard/screens/profile_screen/profile_screen.dart';
import 'package:transfor_admin_dashboard/screens/settings_screen/settings_screen.dart';
import 'package:transfor_admin_dashboard/screens/user_details_screen/user_details_screen.dart';
import 'package:transfor_admin_dashboard/screens/users_screen/users_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = preferences.getBool('isLoggedIn');

    bool goingToLogin = false;

    if (state.fullPath == '/login') {
      goingToLogin = true;
    }

    isLoggedIn ??= false;

    if (!isLoggedIn && !goingToLogin) {
      // Redirect all unauthenticated users to login
      return '/login';
    }

    if (isLoggedIn && goingToLogin) {
      // If logged in and trying to access login page, redirect to dashboard
      return '/dashboard';
    }

    return null; // No redirection
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child); // <- your fixed layout
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => UsersScreen(userType: 'Individual'),
        ),
        GoRoute(
          path: '/provider',
          builder:
              (context, state) => UsersScreen(userType: 'Service Provider'),
        ),
        GoRoute(
          path: '/driver',
          builder: (context, state) => UsersScreen(userType: 'Driver'),
        ),
        GoRoute(
          path: '/pendingProviders',
          builder: (context, state) => UsersScreen(userType: 'Service Provider', isPending: true),
        ),
        GoRoute(
          path: '/pendingDrivers',
          builder: (context, state) => UsersScreen(userType: 'Driver', isPending: true),
        ),
        GoRoute(
          path: '/currentOrders',
          builder:
              (context, state) =>
                  OrdersScreen(ordersCompletedTyep: 'currentOrders'),
        ),
        GoRoute(
          path: '/completedOrders',
          builder:
              (context, state) =>
                  OrdersScreen(ordersCompletedTyep: 'completedOrders'),
        ),
        GoRoute(
          path: '/cancelledOrders',
          builder:
              (context, state) =>
                  OrdersScreen(ordersCompletedTyep: 'cancelledOrders'),
        ),
        GoRoute(
          path: '/payoutRequest',
          builder: (context, state) => PayoutRequestScreen(userType: 'User'),
        ),
        GoRoute(
          path: '/payoutHistory',
          builder: (context, state) => PayoutHistoryScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
        GoRoute(
          path: '/admin-profile',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: '/:userType/details:id',
          builder: (context, state) {
            final int id = int.parse(state.pathParameters['id']!);
            String userType = state.pathParameters['userType']!;
            if (userType == 'individual') {
              userType = 'Individual';
            }
            if (userType == 'service-provider') {
              userType = 'Service Provider';
            }
            if (userType == 'driver') {
              userType = 'Driver';
            }
            return UserDetailsScreen(id: id, userType: userType);
          },
        ),
      ],
    ),
  ],
);
