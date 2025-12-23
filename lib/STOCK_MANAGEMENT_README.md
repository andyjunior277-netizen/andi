# Sistem Kelola Stok Darah - Admin

## Fitur yang Tersedia

### 1. Halaman Kelola Stok Darah (`admin_manage_stock.dart`)
- **Lokasi**: `lib/admin_manage_stock.dart`
- **Fungsi**: Mengelola stok darah yang sudah ditambahkan ke sistem

#### Fitur Utama:
- **Ringkasan Stok**: Menampilkan total kantong darah, jumlah rumah sakit, dan golongan darah
- **Stok per Rumah Sakit**: Menampilkan detail stok darah untuk setiap rumah sakit
- **Stok per Golongan Darah**: Menampilkan total stok berdasarkan golongan darah (A, B, AB, O)
- **Tambah Stok**: Menambahkan stok darah baru
- **Edit Stok**: Mengedit jumlah stok yang sudah ada

#### Cara Menggunakan:
1. Buka Admin Dashboard
2. Klik menu "Kelola Stok Darah"
3. Lihat ringkasan stok di bagian atas
4. Gunakan tombol "+" untuk menambah stok baru
5. Klik "Edit" pada stok yang ingin diubah

### 2. Halaman Data Donor Belum Ditambahkan (`admin_pending_donors.dart`)
- **Lokasi**: `lib/admin_pending_donors.dart`
- **Fungsi**: Menampilkan data donor yang belum ditambahkan ke stok darah

#### Fitur Utama:
- **Daftar Data Donor**: Menampilkan semua data donor yang masuk
- **Informasi Lengkap**: Nama, golongan darah, rumah sakit, telepon, alamat
- **Aksi Telepon**: Langsung menghubungi donor
- **Tambah ke Stok**: Menambahkan data donor ke stok darah

#### Cara Menggunakan:
1. Buka Admin Dashboard
2. Klik menu "Data Belum Ditambahkan"
3. Lihat daftar data donor yang masuk
4. Klik "Tambah ke Stok" untuk menambahkan ke stok darah
5. Atau klik "Telepon" untuk menghubungi donor

### 3. Integrasi dengan Repository (`donor_repository.dart`)
- **Lokasi**: `lib/services/donor_repository.dart`
- **Fungsi**: Mengelola data donor dan stok darah

#### Method yang Ditambahkan:
- `updateStock()`: Mengupdate jumlah stok darah
- `addStock()`: Menambahkan stok darah (sudah ada)
- `hospitalStocks`: Getter untuk mengakses stok per rumah sakit

## Alur Kerja Sistem

### 1. Data Masuk dari User
- User mengajukan donor melalui aplikasi
- Data tersimpan di `DonorRepository.submissions`

### 2. Admin Melihat Data
- Admin dapat melihat data di "Data Belum Ditambahkan"
- Admin dapat menghubungi donor untuk konfirmasi

### 3. Menambahkan ke Stok
- Admin klik "Tambah ke Stok" pada data donor
- Data donor ditambahkan ke stok darah rumah sakit
- Stok dapat dilihat di "Kelola Stok Darah"

### 4. Kelola Stok
- Admin dapat melihat rekapan stok per rumah sakit
- Admin dapat melihat rekapan stok per golongan darah
- Admin dapat menambah atau mengedit stok

## Rekapan yang Tersedia

### 1. Rekapan per Rumah Sakit
- Total kantong darah per rumah sakit
- Detail golongan darah per rumah sakit
- Status stok (tersedia/kosong)

### 2. Rekapan per Golongan Darah
- Total kantong darah per golongan (A, B, AB, O)
- Warna kode untuk setiap golongan darah
- Status ketersediaan

### 3. Ringkasan Umum
- Total kantong darah keseluruhan
- Jumlah rumah sakit yang memiliki stok
- Jumlah golongan darah yang tersedia
- Status umum stok

## Navigasi Menu Admin

1. **Kelola Stok Darah** - Mengelola stok yang sudah ada
2. **Kelola Donor** - Mengelola data donor (fitur lama)
3. **Data Belum Ditambahkan** - Data donor yang belum masuk stok
4. **Permintaan Darah** - (Fitur masa depan)
5. **Laporan** - (Fitur masa depan)

## Catatan Teknis

- Semua data disimpan dalam memory (tidak persistent)
- Untuk production, perlu integrasi dengan database
- UI responsive untuk berbagai ukuran layar
- Menggunakan Material Design components
- Error handling untuk input yang tidak valid

## Pengembangan Selanjutnya

1. **Database Integration**: Menyimpan data ke database
2. **Notifications**: Notifikasi untuk stok rendah
3. **Reports**: Laporan detail stok darah
4. **Export**: Export data ke Excel/PDF
5. **Search & Filter**: Pencarian dan filter data


