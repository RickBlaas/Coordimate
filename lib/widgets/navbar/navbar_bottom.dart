import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Teams',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: calculateSelectedIndex(context),
      onTap: (index) => onItemTapped(index, context),
    );
  }

  int calculateSelectedIndex(BuildContext context) {
    // Get current location
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/home') return 0;
    if (location.startsWith('/teams') || location == '/myteams') return 1;
    return 2;
  }

  // Update onItemTapped method
  void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/myteams');
        break;
      case 2:
        _handleLogout(context);
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _authService.logout();
                if (context.mounted) {
                  context.go('/');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
