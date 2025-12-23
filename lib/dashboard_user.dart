import 'package:flutter/material.dart';
import 'search_donor_page.dart';
import 'search_stock_page.dart';
import 'user_profile_page.dart';
import 'services/auth_service.dart';
import 'package:donor/models/user.dart';

class DashboardUserPage extends StatefulWidget {
  const DashboardUserPage({super.key});

  @override
  State<DashboardUserPage> createState() => _DashboardUserPageState();
}

class _DashboardUserPageState extends State<DashboardUserPage> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Data user tidak ditemukan')),
          );
        }

        final currentUser = snapshot.data!;

        // ⚠️ DEBUG (boleh dihapus di production)
        // ignore: avoid_print
        print('DashboardUserPage - Data user:');
        // ignore: avoid_print
        print('Nama: ${currentUser.name}');
        // ignore: avoid_print
        print('Email: ${currentUser.email}');
        // ignore: avoid_print
        print('Umur: ${currentUser.age}');
        // ignore: avoid_print
        print('Status: ${currentUser.maritalStatus}');

        final pages = <Widget>[
          const SearchDonorPage(),
          const SearchStockPage(),
          UserProfilePage(
            userName: currentUser.name,
            userEmail: currentUser.email,
            userAge: currentUser.age.toString(), // ✅ INT → STRING
            userMaritalStatus: currentUser.maritalStatus,
            userBloodType: null,
          ),
        ];

        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.red,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Pendonor',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital),
                label: 'Stok Darah',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Akun Saya',
              ),
            ],
          ),
        );
      },
    );
  }
}
