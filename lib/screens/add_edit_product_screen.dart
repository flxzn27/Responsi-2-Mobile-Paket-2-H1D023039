import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/product_service.dart';

class AddEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _entryDateCtrl = TextEditingController();
  final _expDateCtrl = TextEditingController();
  final _productService = ProductService();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameCtrl.text = widget.product!['name'];
      _priceCtrl.text = widget.product!['price'].toString();
      _qtyCtrl.text = widget.product!['quantity'].toString();
      _entryDateCtrl.text = widget.product!['entry_date'];
      _expDateCtrl.text = widget.product!['expired_date'];
    }
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ctrl.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameCtrl.text,
        'price': _priceCtrl.text,
        'quantity': _qtyCtrl.text,
        'entry_date': _entryDateCtrl.text,
        'expired_date': _expDateCtrl.text,
      };

      bool success;
      if (widget.product == null) {
        success = await _productService.addProduct(data);
      } else {
        success = await _productService.updateProduct(
          widget.product!['id'],
          data,
        );
      }

      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? "Tambah Inventaris" : "Edit Inventaris",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Barang"),
                validator: (v) => v!.isEmpty ? 'Isi nama' : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Isi harga' : null,
              ),
              TextFormField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(labelText: "Jumlah"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Isi jumlah' : null,
              ),
              TextFormField(
                controller: _entryDateCtrl,
                decoration: const InputDecoration(labelText: "Tanggal Masuk"),
                readOnly: true,
                onTap: () => _pickDate(_entryDateCtrl),
                validator: (v) => v!.isEmpty ? 'Isi tanggal' : null,
              ),
              TextFormField(
                controller: _expDateCtrl,
                decoration: const InputDecoration(
                  labelText: "Tanggal Kedaluwarsa",
                ),
                readOnly: true,
                onTap: () => _pickDate(_expDateCtrl),
                validator: (v) => v!.isEmpty ? 'Isi tanggal' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text("Simpan")),
            ],
          ),
        ),
      ),
    );
  }
}
