import 'package:flutter/material.dart';
import 'services/donor_repository.dart';
import 'services/auth_service.dart';


class AdminManageStockPage extends StatefulWidget {
  const AdminManageStockPage({super.key});

  @override
  State<AdminManageStockPage> createState() => _AdminManageStockPageState();
}

class _AdminManageStockPageState extends State<AdminManageStockPage> {
  final DonorRepository _repo = DonorRepository();
  final AuthService _authService = AuthService();
  String _selectedHospital = '';
  String _selectedBloodType = '';
  final TextEditingController _unitsController = TextEditingController();
  String? _currentHospital;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    _loadData();
  }

  Future<void> _loadAdminData() async {
    try {
      final admin = await _authService.getCurrentAdmin();
      if (admin != null) {
        setState(() {
          _currentHospital = admin.hospitalName;
          _selectedHospital = admin.hospitalName; // Set default hospital
        });
      }
    } catch (e) {
      // Error loading admin data: $e
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data setiap kali halaman ini dibuka
    _loadData();
  }

  void _loadData() {
    setState(() {});
  }

  void _openAddStockDialog() {
    _unitsController.clear();
    _selectedBloodType = '';
    _selectedHospital = '';
    
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Stok Darah'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedHospital.isEmpty ? null : _selectedHospital,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Rumah Sakit',
                      border: OutlineInputBorder(),
                    ),
                    items: _getHospitalList().map((hospital) {
                      return DropdownMenuItem(
                        value: hospital,
                        child: Text(hospital),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setDialogState(() {
                        _selectedHospital = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBloodType.isEmpty ? null : _selectedBloodType,
                    decoration: const InputDecoration(
                      labelText: 'Golongan Darah',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'A', child: Text('A')),
                      DropdownMenuItem(value: 'B', child: Text('B')),
                      DropdownMenuItem(value: 'AB', child: Text('AB')),
                      DropdownMenuItem(value: 'O', child: Text('O')),
                    ],
                    onChanged: (String? value) {
                      setDialogState(() {
                        _selectedBloodType = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _unitsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Kantong',
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
                    if (_selectedHospital.isEmpty || _selectedBloodType.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pilih rumah sakit dan golongan darah')),
                      );
                      return;
                    }
                    
                    final int units = int.tryParse(_unitsController.text.trim()) ?? 0;
                    if (units <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jumlah harus lebih dari 0')),
                      );
                      return;
                    }
                    
                    _repo.addStock(
                      hospital: _selectedHospital,
                      bloodType: _selectedBloodType,
                      units: units,
                    );
                    
                    Navigator.of(context).pop();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Stok ditambahkan ke $_selectedHospital')),
                    );
                  },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openEditStockDialog(String hospital, String bloodType, int currentUnits) {
    _unitsController.text = currentUnits.toString();
    _selectedHospital = hospital;
    _selectedBloodType = bloodType;
    
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Stok Darah'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Rumah Sakit: $hospital'),
              Text('Golongan Darah: $bloodType'),
              const SizedBox(height: 16),
              TextField(
                controller: _unitsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kantong',
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
                final int units = int.tryParse(_unitsController.text.trim()) ?? 0;
                if (units < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jumlah tidak boleh negatif')),
                  );
                  return;
                }
                
                // Update stock
                _repo.updateStock(
                  hospital: hospital,
                  bloodType: bloodType,
                  units: units,
                );
                
                Navigator.of(context).pop();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stok berhasil diperbarui')),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  List<String> _getHospitalList() {
    // Jika admin sudah login, hanya tampilkan rumah sakit admin
    if (_currentHospital != null) {
      return [_currentHospital!];
    }
    
    final Set<String> hospitals = <String>{};
    
    // Get hospitals from submissions
    for (final submission in _repo.submissions) {
      hospitals.add(submission.hospital);
    }
    
    // Get hospitals from existing stocks
    hospitals.addAll(_repo.hospitalStocks.keys);
    
    return hospitals.toList()..sort();
  }

  Map<String, int> _getTotalStockByBloodType(Map<String, Map<String, int>> stocks) {
    final Map<String, int> totals = <String, int>{};
    
    for (final hospitalStocks in stocks.values) {
      for (final entry in hospitalStocks.entries) {
        totals[entry.key] = (totals[entry.key] ?? 0) + entry.value;
      }
    }
    
    return totals;
  }

  Map<String, int> _getTotalStockByHospital(Map<String, Map<String, int>> stocks) {
    final Map<String, int> totals = <String, int>{};
    
    for (final entry in stocks.entries) {
      final int hospitalTotal = entry.value.values.fold(0, (sum, units) => sum + units);
      totals[entry.key] = hospitalTotal;
    }
    
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    // Filter stocks berdasarkan rumah sakit admin
    final Map<String, Map<String, int>> allStocks = _repo.hospitalStocks;
    final Map<String, Map<String, int>> stocks = _currentHospital != null 
        ? {_currentHospital!: _repo.getStocksByHospital(_currentHospital!)}
        : allStocks;
    
    final Map<String, int> totalByBloodType = _getTotalStockByBloodType(stocks);
    final Map<String, int> totalByHospital = _getTotalStockByHospital(stocks);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kelola Stok Darah'),
            if (_currentHospital != null)
              Text(
                _currentHospital!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: stocks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada stok darah',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan stok darah untuk memulai',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _openAddStockDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Stok Pertama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  _buildSummaryCards(totalByBloodType, totalByHospital),
                  
                  const SizedBox(height: 24),
                  
                  // Stock by Hospital
                  _buildStockByHospital(stocks),
                  
                  const SizedBox(height: 24),
                  
                  // Stock by Blood Type
                  _buildStockByBloodType(totalByBloodType),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards(Map<String, int> totalByBloodType, Map<String, int> totalByHospital) {
    final int totalUnits = totalByBloodType.values.fold(0, (sum, units) => sum + units);
    final int totalHospitals = totalByHospital.length;
    final int totalBloodTypes = totalByBloodType.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Stok',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Kantong',
                totalUnits.toString(),
                Icons.bloodtype,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Rumah Sakit',
                totalHospitals.toString(),
                Icons.local_hospital,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Golongan Darah',
                totalBloodTypes.toString(),
                Icons.category,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Status',
                totalUnits > 0 ? 'Tersedia' : 'Kosong',
                Icons.check_circle,
                totalUnits > 0 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockByHospital(Map<String, Map<String, int>> stocks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stok per Rumah Sakit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...stocks.entries.map((entry) {
          final String hospital = entry.key;
          final Map<String, int> hospitalStocks = entry.value;
          final int totalUnits = hospitalStocks.values.fold(0, (sum, units) => sum + units);
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(Icons.local_hospital, color: Colors.red.shade700),
              title: Text(
                hospital,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Total: $totalUnits kantong'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (hospitalStocks.isEmpty)
                        const Text('Tidak ada stok tersedia')
                      else
                        ...hospitalStocks.entries.map((bloodStock) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getBloodTypeColor(bloodStock.key),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Golongan ${bloodStock.key}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${bloodStock.value} kantong',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () => _openEditStockDialog(
                                        hospital,
                                        bloodStock.key,
                                        bloodStock.value,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStockByBloodType(Map<String, int> totalByBloodType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stok per Golongan Darah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (totalByBloodType.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Tidak ada stok tersedia'),
            ),
          )
        else
          ...totalByBloodType.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getBloodTypeColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text('Golongan ${entry.key}'),
                subtitle: Text('${entry.value} kantong tersedia'),
                trailing: Text(
                  entry.value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getBloodTypeColor(entry.key),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Color _getBloodTypeColor(String bloodType) {
    switch (bloodType) {
      case 'A':
        return Colors.red;
      case 'B':
        return Colors.blue;
      case 'AB':
        return Colors.purple;
      case 'O':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

}

