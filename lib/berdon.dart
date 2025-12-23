import 'package:flutter/material.dart';
import 'dashboard_user.dart';
import 'services/auth_service.dart';
import 'admin_login.dart';
import 'user_profile_page.dart';

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            'Masuk / Daftar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Signup'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Tambahkan ValueKey untuk membantu TabBarView menjaga state form saat berpindah tab.
            _LoginForm(key: ValueKey('LoginFormKey')),
            _SignupForm(key: ValueKey('SignupFormKey')),
          ],
        ),
      ),
    );
  }
}

// --- LoginForm Widget (Tidak ada perubahan signifikan, hanya penambahan Key) ---

class _LoginForm extends StatefulWidget {
  const _LoginForm({super.key});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final AuthService auth = AuthService();
    try {
      await auth.login(_emailController.text.trim(), _passwordController.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardUserPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@')) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _submit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Login Admin
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Login sebagai Admin Rumah Sakit'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SignupForm Widget (Perbaikan Error Logis pada SnackBar) ---

class _SignupForm extends StatefulWidget {
  const _SignupForm({super.key});

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  
  // Field untuk user biasa
  final TextEditingController _ageController = TextEditingController();
  String? _selectedStatus; // Untuk status pernikahan
  
  bool _obscure = true;
  bool _obscureConfirm = true;
  String _selectedRole = 'user'; // 'admin' or 'user'

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final AuthService auth = AuthService();
    try {
      if (_selectedRole == 'admin') {
        // Signup admin dengan data dummy untuk rumah sakit
        await auth.adminSignup(
          _emailController.text.trim(),
          _nameController.text.trim(),
          _passwordController.text,
          _hospitalNameController.text.trim(),
          _hospitalAddressController.text.trim(),
          _phoneNumberController.text.trim(),
        );
        if (!mounted) return;
        
        // Signup berhasil, redirect ke halaman login admin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup admin berhasil! Silakan login dengan akun yang baru dibuat.')),
        );
        
        // Redirect ke halaman login admin
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminLoginPage()),
        );
      } else {
        // Signup user biasa
        final email = _emailController.text.trim();
        final name = _nameController.text.trim();
        final password = _passwordController.text;
        final age = _ageController.text.trim();
        final maritalStatus = _selectedStatus;

        await auth.signup(
          email,
          name,
          password,
          age: age,
          maritalStatus: maritalStatus,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran berhasil')),
        );
        final userName = _nameController.text.trim();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => UserProfilePage(
              userName: userName,
              userEmail: email,
              userAge: age,
              userMaritalStatus: maritalStatus,
              userBloodType: null, // Bisa ditambahkan jika ada field golongan darah
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Role selector
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'admin',
                  label: Text('Admin Rumah Sakit'),
                  icon: Icon(Icons.local_hospital),
                ),
                ButtonSegment<String>(
                  value: 'user',
                  label: Text('Pengguna Biasa'),
                  icon: Icon(Icons.person),
                ),
              ],
              selected: <String>{_selectedRole},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedRole = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            // Form fields khusus untuk admin
            if (_selectedRole == 'admin') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _hospitalNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Rumah Sakit',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama rumah sakit tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hospitalAddressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Rumah Sakit',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat rumah sakit tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon Rumah Sakit',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                helperText: _selectedRole == 'admin'
                    ? 'Data dummy: admin@rsud.com, admin@rsj.com, admin@rsudjakarta.com (password: admin123). Atau buat akun baru dengan format: namaadmin@admin.rumahsakit.com'
                    : 'Contoh: userbiasa@gmail.com',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                final trimmed = value.trim();
                if (_selectedRole == 'admin') {
                  // Validasi email admin yang lebih fleksibel untuk data dummy
                  final adminPattern = RegExp(r'^[^@\s]+@.*$', caseSensitive: false);
                  if (!adminPattern.hasMatch(trimmed)) {
                    return 'Format email tidak valid';
                  }
                } else {
                  final basicEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}$');
                  if (!basicEmail.hasMatch(trimmed)) {
                    return 'Format email tidak valid';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password wajib';
                }
                if (value != _passwordController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
            
            // Field khusus untuk user biasa (umur dan status)
            if (_selectedRole == 'user') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Umur tidak boleh kosong';
                  }
                  final age = int.tryParse(value.trim());
                  if (age == null) {
                    return 'Umur harus berupa angka';
                  }
                  if (age < 17 || age > 65) {
                    return 'Umur harus antara 17-65 tahun';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status Pernikahan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.family_restroom),
                ),
                value: _selectedStatus,
                hint: const Text('Pilih Status Pernikahan'),
                items: const [
                  DropdownMenuItem(value: 'Belum Menikah', child: Text('Belum Menikah')),
                  DropdownMenuItem(value: 'Menikah', child: Text('Menikah')),
                  DropdownMenuItem(value: 'Cerai', child: Text('Cerai')),
                  DropdownMenuItem(value: 'Janda', child: Text('Janda')),
                  DropdownMenuItem(value: 'Duda', child: Text('Duda')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status pernikahan tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
            
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _submit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Daftar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Login Admin
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Login sebagai Admin Rumah Sakit'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}