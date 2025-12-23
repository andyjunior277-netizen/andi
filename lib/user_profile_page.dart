import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'models/user.dart';

class UserProfilePage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userAge;
  final String? userMaritalStatus;
  final String? userBloodType;

  const UserProfilePage({
    super.key,
    this.userName,
    this.userEmail,
    this.userAge,
    this.userMaritalStatus,
    this.userBloodType,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  // ===== Tambahan Profile Editable =====
  final TextEditingController riwayatPenyakitController =
      TextEditingController();
  final TextEditingController riwayatDonorController =
      TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  String? jenisKelamin;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    riwayatPenyakitController.dispose();
    riwayatDonorController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void _simpanProfileTambahan() {
    final dataTambahan = {
      'riwayat_penyakit': riwayatPenyakitController.text,
      'riwayat_donor': riwayatDonorController.text,
      'jenis_kelamin': jenisKelamin,
      'alamat': alamatController.text,
    };

    debugPrint('Profile tambahan: $dataTambahan');

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile berhasil diperbarui')),
    );

    // TODO: simpan ke database / API
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile User'),
          backgroundColor: Colors.red,
        ),
        body: const Center(child: Text('Tidak ada data user')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile User'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header =====
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red.shade100,
                      child: Icon(Icons.person,
                          size: 40, color: Colors.red.shade700),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName ??
                                _currentUser?.name ??
                                'Nama tidak tersedia',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.userEmail ??
                                _currentUser?.email ??
                                '-',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== Informasi Personal =====
            const Text(
              'Informasi Personal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                   _buildInfoRow(
                      Icons.cake,
                      'Umur',
                      widget.userAge ??
                          _currentUser?.age.toString() ??
                          'Tidak diisi',
                    ),
                    _buildInfoRow(
                        Icons.family_restroom,
                        'Status Pernikahan',
                        widget.userMaritalStatus ??
                            _currentUser?.maritalStatus ??
                            'Tidak diisi'),
                    _buildInfoRow(
                        Icons.email,
                        'Email',
                        widget.userEmail ??
                            _currentUser?.email ??
                            '-'),
                    _buildInfoRow(
                        Icons.person,
                        'Nama Lengkap',
                        widget.userName ??
                            _currentUser?.name ??
                            '-'),
                    if (widget.userBloodType != null)
                      _buildInfoRow(Icons.bloodtype, 'Golongan Darah',
                          widget.userBloodType!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== Informasi Tambahan (Editable) =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informasi Tambahan',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                )
              ],
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: riwayatPenyakitController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                          labelText: 'Riwayat Penyakit'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: riwayatDonorController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                          labelText: 'Riwayat Donor Darah'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: jenisKelamin,
                      decoration:
                          const InputDecoration(labelText: 'Jenis Kelamin'),
                      items: const [
                        DropdownMenuItem(
                            value: 'L', child: Text('Laki-laki')),
                        DropdownMenuItem(
                            value: 'P', child: Text('Perempuan')),
                      ],
                      onChanged: _isEditing
                          ? (val) =>
                              setState(() => jenisKelamin = val)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: alamatController,
                      enabled: _isEditing,
                      decoration:
                          const InputDecoration(labelText: 'Alamat'),
                      maxLines: 3,
                    ),
                    if (_isEditing) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _simpanProfileTambahan,
                        child: const Text('Simpan'),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
