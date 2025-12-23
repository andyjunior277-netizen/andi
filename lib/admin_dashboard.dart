import 'package:flutter/material.dart';
// Asumsi AdminModel ada di sini
import 'admin_manage_stock.dart'; // Diaktifkan kembali
import 'admin_pending_donors.dart';
import 'services/auth_service.dart';
import 'package:donor/models/admin_model.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _authService = AuthService();
  AdminModel? _currentAdmin;

  @override
  void initState() {
    super.initState();
    _loadCurrentAdmin();
  }
AdminModel? admin;

  Future<void>  _loadCurrentAdmin() async {
  final result = await AuthService().getCurrentAdmin();
  setState(() {
    admin = result;
  });
}

  // Tambahkan pengecekan mounted di _logout juga, meskipun sudah ada,
  // untuk konsistensi di dalam async function
  Future<void> _logout() async {
    await _authService.adminLogout();
    if (mounted) {
      // Pastikan rute '/' tersedia di MaterialApp Anda
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentAdmin == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    // Menggunakan LayoutBuilder untuk mendapatkan batasan ukuran jika diperlukan
    // Namun, kita akan fokus pada penggunaan Expanded dan properti GridView
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan informasi admin
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red.shade100,
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 30,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Menggunakan Expanded untuk Text agar tidak overflow
                        Expanded( 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // Gunakan softWrap dan overflow untuk memastikan teks panjang tidak overflow
                                'Selamat datang, ${_currentAdmin!.name}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2, 
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentAdmin!.hospitalName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_hospital, size: 16, color: Colors.red.shade700),
                              const SizedBox(width: 4),
                              Text(
                                'Informasi Rumah Sakit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Memastikan Text yang berisi alamat dan telepon tidak overflow
                          Text(
                            'Alamat: ${_currentAdmin!.hospitalAddress}',
                            style: const TextStyle(fontSize: 14),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // Batasi baris jika alamat terlalu panjang
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Telepon: ${_currentAdmin!.phoneNumber}',
                            style: const TextStyle(fontSize: 14),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Menu utama admin
            const Text(
              'Menu Operasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              // PERBAIKAN: Mengurangi childAspectRatio menjadi 1.1 
              // untuk memberikan lebih banyak ruang vertikal pada item.
              childAspectRatio: 1.1, 
              children: [
                  // Menu Kelola Stok Darah (Diaktifkan kembali)
                  _buildMenuCard(
                    icon: Icons.bloodtype,
                    title: 'Kelola Stok Darah',
                    subtitle: 'Kelola persediaan darah',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AdminManageStockPage()),
                      );
                    },
                  ),
                  // Menu Data Pending (Dipertahankan)
                  _buildMenuCard(
                    icon: Icons.person_add_alt_1,
                    title: 'Data Pending',
                    subtitle: 'Donor yang perlu diverifikasi',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AdminPendingDonorsPage()),
                      );
                    },
                  ),
                  // Menu Kelola Donor, Permintaan Darah, dan Laporan telah dihapus
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.red.shade50,
        highlightColor: Colors.red.shade100,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
