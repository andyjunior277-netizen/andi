import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/donor_repository.dart';
import 'services/auth_service.dart';
import 'models/donor_submission.dart';

class AdminPendingDonorsPage extends StatefulWidget {
  const AdminPendingDonorsPage({super.key});

  @override
  State<AdminPendingDonorsPage> createState() => _AdminPendingDonorsPageState();
}

class _AdminPendingDonorsPageState extends State<AdminPendingDonorsPage> {
  final DonorRepository _repo = DonorRepository();
  final AuthService _authService = AuthService();
  String? _currentHospital;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    try {
      final admin = await _authService.getCurrentAdmin();
      if (admin != null) {
        setState(() {
          _currentHospital = admin.hospitalName;
        });
      }
    } catch (e) {
      // Error loading admin data: $e
    }
  }

  Future<void> _callNumber(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka aplikasi telepon')),
      );
    }
  }

  void _openAddStockDialog(DonorSubmission submission) {
    final TextEditingController unitsController = TextEditingController(text: '1');
    String selectedBloodType = submission.bloodType;
    
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah ke Stok Darah'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Donor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Nama: ${submission.name}'),
                          Text('Golongan: ${submission.bloodType}'),
                          Text('Rumah Sakit: ${submission.hospital}'),
                          Text('Telepon: ${submission.phone}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Golongan:'),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: selectedBloodType,
                        items: const [
                          DropdownMenuItem(value: 'A', child: Text('A')),
                          DropdownMenuItem(value: 'B', child: Text('B')),
                          DropdownMenuItem(value: 'AB', child: Text('AB')),
                          DropdownMenuItem(value: 'O', child: Text('O')),
                        ],
                        onChanged: (String? v) {
                          if (v == null) return;
                          setDialogState(() {
                            selectedBloodType = v;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: unitsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah kantong',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final int units = int.tryParse(unitsController.text.trim()) ?? 0;
                    if (units <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jumlah harus lebih dari 0')),
                      );
                      return;
                    }
                    
                    // Tambahkan stok dan hapus dari data pending
                    _repo.addStockFromSubmission(submission, units);
                    
                    Navigator.of(context).pop();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stok ditambahkan ke ${submission.hospital} dan data dihapus dari pending'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tambah ke Stok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter submissions berdasarkan rumah sakit admin
    final List<DonorSubmission> submissions = _currentHospital != null 
        ? _repo.getSubmissionsByHospital(_currentHospital!)
        : _repo.submissions;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Donor Belum Ditambahkan'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: submissions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada data pending',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Semua data donor telah diproses atau belum ada pengajuan baru',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Semua data telah diproses dengan baik!',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Header dengan informasi
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.orange.shade50,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Total Data Donor: ${submissions.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      if (_currentHospital != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.local_hospital, size: 16, color: Colors.orange.shade600),
                            const SizedBox(width: 4),
                            Text(
                              'Rumah Sakit: $_currentHospital',
                              style: TextStyle(
                                color: Colors.orange.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Klik "Tambah ke Stok" untuk menambahkan data donor ke stok darah',
                        style: TextStyle(
                          color: Colors.orange.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // List data donor
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: submissions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final DonorSubmission s = submissions[index];
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.bloodtype, color: Colors.red.shade700),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      s.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.red.shade100),
                                    ),
                                    child: Text('Gol. ${s.bloodType}'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(s.phone),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(s.address)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.local_hospital, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(s.hospital),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text('${s.gender} • ${s.maritalStatus}'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _callNumber(s.phone),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    icon: const Icon(Icons.call),
                                    label: const Text('Telepon'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _openAddStockDialog(s),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Tambah ke Stok'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
