# Fitur Admin Rumah Sakit

## Data Dummy Admin (Siap Pakai)

Aplikasi ini memiliki 3 data dummy admin rumah sakit yang **SIAP DIGUNAKAN untuk login langsung** tanpa perlu signup terlebih dahulu.

### 1. Dr. Ahmad Wijaya
- **Email:** admin@rsud.com
- **Password:** admin123
- **Rumah Sakit:** RSUD Dr. Soetomo
- **Alamat:** Jl. Mayjen Prof. Dr. Moestopo No.6-8, Airlangga, Kec. Gubeng, Surabaya
- **Telepon:** 031-5020088

### 2. Dr. Siti Nurhaliza
- **Email:** admin@rsj.com
- **Password:** admin123
- **Rumah Sakit:** RSJ Dr. Radjiman Wediodiningrat
- **Alamat:** Jl. Raya Lawang No.1, Lawang, Malang
- **Telepon:** 0341-426000

### 3. Dr. Budi Santoso
- **Email:** admin@rsudjakarta.com
- **Password:** admin123
- **Rumah Sakit:** RSUD Pasar Minggu
- **Alamat:** Jl. TB Simatupang No.1, Pasar Minggu, Jakarta Selatan
- **Telepon:** 021-80880888

**✅ SIAP PAKAI:** Data dummy ini sudah terdaftar di sistem dan bisa langsung digunakan untuk login.

## Cara Menggunakan

### 1. Login sebagai Admin (Data Dummy)
1. Buka aplikasi
2. Di halaman login/signup, klik tombol "Login sebagai Admin Rumah Sakit"
3. Masukkan email dan password dari data dummy:
   - Email: `admin@rsj.com` (atau `admin@rsud.com`, `admin@rsudjakarta.com`)
   - Password: `admin123`
4. Setelah login berhasil, akan masuk ke halaman Admin Dashboard

**✅ Data dummy sudah siap pakai!**

### 2. Signup Admin Baru
1. Di halaman signup, pilih "Admin Rumah Sakit" pada segmented button
2. Isi form dengan data:
   - Nama Lengkap
   - Nama Rumah Sakit
   - Alamat Rumah Sakit
   - Nomor Telepon Rumah Sakit
   - Email (format yang didukung: admin@rsud.com, admin@rsj.com, admin@rsudjakarta.com, atau namaadmin@admin.rumahsakit.com)
   - Password
   - Konfirmasi Password
3. Klik "Daftar"
4. Setelah signup berhasil, akan diarahkan ke halaman login admin
5. Login dengan email dan password yang baru dibuat

**Cara Menggunakan Data Dummy:**
1. **Signup dengan Data Dummy:**
   - Pilih "Admin Rumah Sakit" di halaman signup
   - Isi form dengan data yang sama persis dengan data dummy:
     - Email: `admin@rsud.com`
     - Nama: `Dr. Ahmad Wijaya`
     - Password: `admin123`
     - Nama Rumah Sakit: `RSUD Dr. Soetomo`
     - Alamat: `Jl. Mayjen Prof. Dr. Moestopo No.6-8, Airlangga, Kec. Gubeng, Surabaya`
     - Telepon: `031-5020088`
   - Klik "Daftar"
   - Setelah signup berhasil, akan diarahkan ke halaman login

2. **Login dengan Data yang Sama:**
   - Di halaman login admin, masukkan:
     - Email: `admin@rsud.com`
     - Password: `admin123`
   - Klik "Login"
   - Akan masuk ke Admin Dashboard

**⚠️ PENTING:** Email dan password yang digunakan saat login HARUS SAMA dengan yang digunakan saat signup.

## Fitur Admin Dashboard

Halaman admin dashboard menampilkan:
- Informasi admin dan rumah sakit
- Menu utama admin:
  - Kelola Stok Darah
  - Kelola Donor
  - Permintaan Darah
  - Laporan

*Catatan: Menu-menu tersebut masih dalam tahap pengembangan dan akan menampilkan notifikasi "Fitur akan segera hadir" ketika diklik.*

## File yang Dibuat/Diupdate

1. **lib/models/user.dart** - Menambahkan model AdminModel
2. **lib/services/auth_service.dart** - Menambahkan method untuk admin login/signup
3. **lib/admin_dashboard.dart** - Halaman dashboard admin
4. **lib/admin_login.dart** - Halaman login khusus admin
5. **lib/berdon.dart** - Menambahkan tombol login admin dan form signup admin

## Struktur Data Admin

```dart
class AdminModel {
  final String id;
  final String email;
  final String name;
  final String password;
  final String hospitalName;
  final String hospitalAddress;
  final String phoneNumber;
}
```

## Session Management

Admin memiliki session terpisah dari user biasa:
- Session admin disimpan dengan key 'session_admin_email'
- Method logout admin: `adminLogout()`
- Method get current admin: `getCurrentAdmin()`
