# Responsi 2 Mobile Paket 2 (H1D023039)
# Inventaris Bahan Alfan (Full CRUD + Laravel API)

Aplikasi Mobile Flutter yang terhubung penuh dengan REST API (Laravel Sanctum) untuk mengelola data inventaris bahan. Aplikasi ini dibuat untuk memenuhi tugas Responsi Praktikum Pemrograman Mobile.

**Spesifikasi Teknis:**
- **Frontend:** Flutter
- **Backend:** Laravel (API + Sanctum Authentication)
- **HTTP Request:** Package `http` (GET, POST, PUT, DELETE)
- **State Management:** `setState` (StatefulWidget)
- **Local Storage:** `shared_preferences` (Menyimpan Token Login)
- **UI Theme:** Dominan Warna Hijau (Sesuai Ketentuan)

# DATA DIRI

**Nama** : Alfan Fauzan Ridlo  
**NIM** : H1D023039  
**Shift** : C
**Shift Baru** : B
## SPESIFIKASI API
Berikut adalah dokumentasi REST API yang digunakan dalam aplikasi ini, dibangun menggunakan Framework **Laravel**.

### A. Autentikasi

#### 1. Registrasi
* **Endpoint:** `/register`
* **Method:** `POST`
* **Header:** `Content-Type: application/json`
* **Body:**
    ```json
    {
        "name": "Alfan Fauzan",
        "email": "alfan@example.com",
        "password": "password123"
    }
    ```
* **Response:**
    ```json
    {
        "message": "Register success",
        "access_token": "1|PyDnQ...",
        "token_type": "Bearer"
    }
    ```

#### 2. Login
* **Endpoint:** `/login`
* **Method:** `POST`
* **Header:** `Content-Type: application/json`
* **Body:**
    ```json
    {
        "email": "alfan@example.com",
        "password": "password123"
    }
    ```
* **Response:**
    ```json
    {
        "message": "Login success",
        "access_token": "2|HsJk...",
        "token_type": "Bearer",
        "user": {
            "id": 1,
            "name": "Alfan Fauzan",
            "email": "alfan@example.com"
        }
    }
    ```

#### 3. Logout
* **Endpoint:** `/logout`
* **Method:** `POST`
* **Header:** * `Content-Type: application/json`
    * `Authorization: Bearer <token>`
* **Response:**
    ```json
    {
        "message": "Logged out successfully"
    }
    ```

### B. Produk (Inventaris)

#### 1. List Produk (Read)
* **Endpoint:** `/products`
* **Method:** `GET`
* **Header:** `Authorization: Bearer <token>`
* **Response:**
    ```json
    {
        "status": true,
        "message": "Data ditemukan",
        "data": [
            {
                "id": 1,
                "name": "Tepung Terigu",
                "price": 12000,
                "quantity": 50,
                "entry_date": "2024-12-01",
                "expired_date": "2025-12-01"
            }
        ]
    }
    ```

#### 2. Tambah Produk (Create)
* **Endpoint:** `/products`
* **Method:** `POST`
* **Header:** * `Content-Type: application/json`
    * `Authorization: Bearer <token>`
* **Body:**
    ```json
    {
        "name": "Gula Pasir",
        "price": 15000,
        "quantity": 20,
        "entry_date": "2024-12-06",
        "expired_date": "2025-06-01"
    }
    ```
* **Response:**
    ```json
    {
        "status": true,
        "message": "Barang berhasil ditambahkan",
        "data": { ... }
    }
    ```

#### 3. Update Produk (Edit)
* **Endpoint:** `/products/{id}`
* **Method:** `PUT`
* **Header:** * `Content-Type: application/json`
    * `Authorization: Bearer <token>`
* **Body:**
    ```json
    {
        "name": "Gula Pasir Premium",
        "price": 18000,
        "quantity": 20,
        "entry_date": "2024-12-06",
        "expired_date": "2025-06-01"
    }
    ```
* **Response:**
    ```json
    {
        "status": true,
        "message": "Barang berhasil diupdate",
        "data": { ... }
    }
    ```

#### 4. Hapus Produk (Delete)
* **Endpoint:** `/products/{id}`
* **Method:** `DELETE`
* **Header:** `Authorization: Bearer <token>`
* **Response:**
    ```json
    {
        "status": true,
        "message": "Barang berhasil dihapus"
    }
    ```

---

# FITUR UTAMA

1.  **Autentikasi User** (Register & Login dengan Token Bearer)
2.  **CRUD Inventaris** (Create, Read, Update, Delete)
3.  **Validasi Input** (Form tidak boleh kosong, format tanggal)
4.  **Persistent Login** (User tetap login meski aplikasi ditutup)
5.  **Desain UI Modern** (Clean, Green Theme, Rounded Corners)

# DEMO VIDEO
https://github.com/user-attachments/assets/7ffb430c-8724-423a-8e03-83dab4f03ab3


# ALUR APLIKASI & PENJELASAN KODE

## 1. REGISTRASI (SIGN UP)

- User mengisi: Nama, Email, dan Password.
- Sistem mengirim request `POST` ke endpoint `/register`.
- Terdapat loading indicator saat proses berlangsung.
- Jika sukses, user diarahkan untuk Login.

### Kode Implementasi (UI & Logic):
```dart
// register_screen.dart
void _register() async {
  setState(() => _isLoading = true);
  bool success = await _authService.register(
    _nameCtrl.text,
    _emailCtrl.text,
    _passCtrl.text,
  );
  setState(() => _isLoading = false);

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Berhasil Daftar, Silakan Login")),
    );
    Navigator.pop(context);
  }
}
````

## 2\. LOGIN (AUTHENTICATION)

  - User memasukkan Email dan Password.
  - Request `POST` dikirim ke `/login`.
  - Jika berhasil (Code 200), **Token** disimpan ke dalam `SharedPreferences`.
  - User diarahkan ke Halaman Utama (Home).

### Kode Implementasi (Service):

```dart
// auth_service.dart
Future<bool> login(String email, String password) async {
  final response = await http.post(
    Uri.parse(ApiConstants.login),
    body: {'email': email, 'password': password},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token']); // Simpan Token
    return true;
  }
  return false;
}
```

## 3\. LIST INVENTARIS (READ)

  - Mengambil data dari API `/products` menggunakan method `GET`.
  - Menggunakan `ListView.builder` untuk menampilkan daftar barang.
  - Menampilkan Nama, Harga, Stok, dan Tanggal Kedaluwarsa.
  - Terdapat tombol Edit dan Hapus pada setiap item.

### Kode Implementasi (Fetch Data):

```dart
// home_screen.dart
void _refresh() async {
  setState(() => _isLoading = true);
  final data = await _productService.getProducts();
  setState(() {
    _products = data;
    _isLoading = false;
  });
}
```

## 4\. TAMBAH INVENTARIS (CREATE)

  - User mengisi form: Nama Barang, Harga, Jumlah, Tanggal Masuk, Tgl Kedaluwarsa.
  - Menggunakan `DatePicker` untuk memilih tanggal.
  - Data dikirim via method `POST`.

### Kode Implementasi (UI Form):

```dart
// add_edit_product_screen.dart
void _save() async {
  if (_formKey.currentState!.validate()) {
    final data = {
      'name': _nameCtrl.text,
      'price': _priceCtrl.text,
      'quantity': _qtyCtrl.text,
      'entry_date': _entryDateCtrl.text,
      'expired_date': _expDateCtrl.text,
    };
    
    // Panggil service addProduct
    success = await _productService.addProduct(data);
    
    if (success) Navigator.pop(context);
  }
}
```

## 5\. EDIT INVENTARIS (UPDATE)

  - Form otomatis terisi dengan data barang yang dipilih.
  - Logika membedakan antara Tambah dan Edit berdasarkan `widget.product`.
  - Data dikirim via method `PUT` ke endpoint `/products/{id}`.

### Kode Implementasi (Logic):

```dart
// add_edit_product_screen.dart (Logic Check)
if (widget.product == null) {
  success = await _productService.addProduct(data);
} else {
  success = await _productService.updateProduct(
    widget.product!['id'],
    data,
  );
}
```

## 6\. HAPUS INVENTARIS (DELETE)

  - Muncul `AlertDialog` konfirmasi sebelum menghapus.
  - Jika user menekan "Hapus", request `DELETE` dikirim ke API.
  - List otomatis di-refresh setelah penghapusan berhasil.

### Kode Implementasi (Dialog):

```dart
// home_screen.dart
final confirm = await showDialog<bool>(
  context: context,
  builder: (ctx) => AlertDialog(
    title: const Text("Hapus Barang?"),
    content: const Text("Data yang dihapus tidak bisa dikembalikan."),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () => Navigator.pop(ctx, true), 
        child: const Text("Hapus"),
      ),
    ],
  ),
);
```

## 7\. LOGOUT

  - Menghapus token dari `SharedPreferences`.
  - Mengirim request logout ke API (opsional/tergantung backend) untuk invalidasi token.
  - Mengembalikan user ke halaman Login.

<!-- end list -->

```dart
// home_screen.dart
void _logout() async {
  await AuthService().logout();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
}
```
