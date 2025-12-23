import 'package:flutter/material.dart';
import 'services/donor_repository.dart';

class SearchStockPage extends StatefulWidget {
  const SearchStockPage({super.key});

  @override
  State<SearchStockPage> createState() => _SearchStockPageState();
}

class _SearchStockPageState extends State<SearchStockPage> {
  final DonorRepository _repo = DonorRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  List<MapEntry<String, Map<String, int>>> _getFilteredHospitals() {
    return _repo.hospitalStocks.entries.toList();
  }


  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, Map<String, int>>> filteredHospitals = _getFilteredHospitals();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Darah'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _repo.hospitalStocks.isEmpty
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
                    'Belum ada stok darah tersedia',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Admin belum menambahkan stok darah',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildHospitalList(filteredHospitals),
            ),
    );
  }


  Widget _buildHospitalList(List<MapEntry<String, Map<String, int>>> hospitals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rumah Sakit dengan Stok Darah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...hospitals.map((entry) {
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
                        ...hospitalStocks.entries.where((entry) => entry.value > 0).map((bloodStock) {
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
                                Text(
                                  '${bloodStock.value} kantong',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getBloodTypeColor(bloodStock.key),
                                  ),
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

