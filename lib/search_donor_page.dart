import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchDonorPage extends StatefulWidget {
  const SearchDonorPage({super.key});

  @override
  State<SearchDonorPage> createState() => _SearchDonorPageState();
}

class _SearchDonorPageState extends State<SearchDonorPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGender = 'Pria';
  String? _selectedBloodType = 'A';
  String? _selectedMaritalStatus = 'Belum Kawin';
  String? _selectedHospital;

bool _agreeAge = false;
bool _agreeWeight = false;
bool _agreeHealthy = false;
bool _agreeNotSick = false;
bool _agreeNotPregnant = false;
bool _agreeNoDisease = false;
bool _agreeDonationInterval = false;
bool _agreeMedicalCheck = false;


  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  final List<String> _genders = ['Pria', 'Wanita'];
  final List<String> _bloodTypes = ['A', 'B', 'AB', 'O'];
  final List<String> _maritalStatuses = ['Belum Kawin', 'Kawin'];

  final List<Map<String, String>> _hospitals = [
    {
      'name': 'RSUD Dr. Soetomo',
      'address': 'Jl. Mayjen Prof. Dr. Moestopo No.6-8, Airlangga, Surabaya',
      'phone': '031-5020088',
    },
    {
      'name': 'RSJ Dr. Radjiman Wediodiningrat',
      'address': 'Jl. Raya Lawang No.1, Lawang, Malang',
      'phone': '0341-426000',
    },
    {
      'name': 'RSUD Pasar Minggu',
      'address': 'Jl. TB Simatupang No.1, Pasar Minggu, Jakarta Selatan',
      'phone': '021-80880888',
    },
    {
      'name': 'RS Siloam',
      'address': 'Jl. Raya Gubeng No.70, Surabaya',
      'phone': '031-5030000',
    },
    {
      'name': 'RS Premier Jatinegara',
      'address': 'Jl. Raya Jatinegara Timur No.85-87, Jakarta Timur',
      'phone': '021-8190000',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  // Fungsi menampilkan form donor darah
  void _showDonationForm() {
    setState(() {
      _selectedGender = _genders.first;
      _selectedBloodType = _bloodTypes.first;
      _selectedMaritalStatus = _maritalStatuses.first;
      _selectedHospital = _hospitals.first['name'];
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // IconButton(
                                //   icon: const Icon(Icons.arrow_back,
                                //       color: Colors.red),
                                //   // onPressed: () => Navigator.of(context).pop(),
                                // ),
                                const Expanded(
                                  child: Text(
                                    'Formulir Donasi Darah',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 48),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nama Lengkap',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan nama lengkap',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Nama harus diisi' : null,
                                ),
                                const SizedBox(height: 20),

                                const Text('Jenis Kelamin',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  children: _genders.map((g) {
                                    return Expanded(
                                      child: RadioListTile<String>(
                                        title: Text(g),
                                        value: g,
                                        groupValue: _selectedGender,
                                        onChanged: (val) {
                                          setModalState(
                                              () => _selectedGender = val);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),

                                const Text('Nomor Telepon',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan nomor telepon',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.phone),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nomor telepon harus diisi';
                                    }
                                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return 'Nomor telepon harus angka';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                const Text('Alamat',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                TextFormField(
                                  controller: _addressController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan alamat lengkap',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.location_on),
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Alamat harus diisi' : null,
                                ),
                                const SizedBox(height: 20),

                                const Text('Lokasi Rumah Sakit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedHospital,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon:
                                        const Icon(Icons.local_hospital),
                                  ),
                                  items: _hospitals.map((h) {
                                    return DropdownMenuItem<String>(
                                      value: h['name'],
                                      child: Text(h['name']!),
                                    );
                                  }).toList(),
                                  onChanged: (v) =>
                                      setModalState(() => _selectedHospital = v),
                                ),
                                const SizedBox(height: 20),

                                const Text('Golongan Darah',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                DropdownButtonFormField<String>(
                                  value: _selectedBloodType,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.bloodtype),
                                  ),
                                  items: _bloodTypes.map((b) {
                                    return DropdownMenuItem<String>(
                                      value: b,
                                      child: Text(b),
                                    );
                                  }).toList(),
                                  onChanged: (v) =>
                                      setModalState(() => _selectedBloodType = v),
                                ),
                                const SizedBox(height: 20),

                                const Text('Status Pernikahan',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  children: _maritalStatuses.map((s) {
                                    return Expanded(
                                      child: RadioListTile<String>(
                                        title: Text(s),
                                        value: s,
                                        groupValue: _selectedMaritalStatus,
                                        onChanged: (val) => setModalState(
                                            () => _selectedMaritalStatus = val),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ==== KODE KAMU DIMASUKKAN DI SINI ====

                    const SizedBox(height: 20),
                    const Text(
                      'Syarat Donor Darah',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    CheckboxListTile(
                      value: _agreeAge,
                      onChanged: (v) =>
                          setModalState(() => _agreeAge = v!),
                      title: const Text('Saya berusia 17–60 tahun'),
                    ),

                    CheckboxListTile(
                      value: _agreeWeight,
                      onChanged: (v) =>
                          setModalState(() => _agreeWeight = v!),
                      title:
                          const Text('Berat badan saya minimal 45 kg'),
                    ),

                    CheckboxListTile(
                      value: _agreeHealthy,
                      onChanged: (v) =>
                          setModalState(() => _agreeHealthy = v!),
                      title: const Text(
                          'Saya dalam kondisi sehat jasmani dan rohani'),
                    ),

                    CheckboxListTile(
                      value: _agreeNotSick,
                      onChanged: (v) =>
                          setModalState(() => _agreeNotSick = v!),
                      title: const Text(
                          'Saya tidak sedang demam, flu, atau sakit'),
                    ),

                    if (_selectedGender == 'Wanita')
                      CheckboxListTile(
                        value: _agreeNotPregnant,
                        onChanged: (v) => setModalState(
                            () => _agreeNotPregnant = v!),
                        title: const Text(
                            'Saya tidak sedang hamil atau menyusui'),
                      ),

                    CheckboxListTile(
                      value: _agreeNoDisease,
                      onChanged: (v) =>
                          setModalState(() => _agreeNoDisease = v!),
                      title: const Text(
                          'Saya tidak memiliki penyakit menular (HIV, Hepatitis, dll)'),
                    ),

                    CheckboxListTile(
                      value: _agreeDonationInterval,
                      onChanged: (v) => setModalState(
                          () => _agreeDonationInterval = v!),
                      title: const Text(
                          'Sudah lebih dari 8 minggu sejak donor darah terakhir'),
                    ),

                    CheckboxListTile(
                      value: _agreeMedicalCheck,
                      onChanged: (v) => setModalState(
                          () => _agreeMedicalCheck = v!),
                      title: const Text(
                          'Saya bersedia menjalani pemeriksaan lanjutan oleh petugas medis'),
                    ),

                    const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm();
                            // Navigator.pop(context); // tutup bottom sheet jika lolos
                          },
                          child: const Text('Kirim & Lanjutkan'),
  ),
),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  },
  child: const Text('Cek Syarat Donor'),
),

                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

void _submitForm() {
  // 1. Validasi checklist syarat donor
  final bool isEligible =
      _agreeAge &&
      _agreeWeight &&
      _agreeHealthy &&
      _agreeNotSick &&
      _agreeNoDisease &&
      _agreeDonationInterval &&
      _agreeMedicalCheck &&
      (_selectedGender != 'Wanita' || _agreeNotPregnant);

  if (!isEligible) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua syarat donor darah harus disetujui'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // 2. Validasi form input (jika kamu pakai Form)
  if (!_formKey.currentState!.validate()) {
    return;
  }

  _formKey.currentState!.save();

  // 3. (Opsional tapi dianjurkan) Feedback sukses
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Data donor berhasil dikirim'),
      backgroundColor: Colors.green,
    ),
  );

  // 4. TODO: kirim ke repository / backend jika sudah siap
  // DonorRepository().submit(DonorSubmission(...));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Pencarian Pendonor'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 🔴 LOGO KECIL INTERAKTIF
                GestureDetector(
                  onTapDown: (_) => _scaleController.forward(),
                  onTapUp: (_) => _scaleController.reverse(),
                  onTapCancel: () => _scaleController.reverse(),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Logo darah terpilih! 🩸'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ));
                  },
                  child: AnimatedBuilder(
                    animation:
                        Listenable.merge([_pulseAnimation, _scaleAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 100, // 🔽 Ukuran logo diperkecil
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    blurRadius: 15 * _pulseAnimation.value,
                                    spreadRadius: 4 * _pulseAnimation.value,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/logo_darah (2).jpg',
                                  width: 70, // 🔽 gambar dalam lingkaran diperkecil
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.bloodtype,
                                        size: 50, color: Colors.red);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Donasi Darah',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bantu sesama dengan mendonorkan darah',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                ElevatedButton.icon(
                  onPressed: _showDonationForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  icon: const Icon(Icons.add_circle, size: 24),
                  label: const Text(
                    'Donor Darah',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pastikan Anda dalam kondisi sehat dan memenuhi syarat untuk mendonorkan darah',
                          style:
                              TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
