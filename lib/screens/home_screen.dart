import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'add_edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productService = ProductService();
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    final data = await _productService.getProducts();
    setState(() => _products = data);
  }

  void _logout() async {
    await AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  void _delete(int id) async {
    await _productService.deleteProduct(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Nama Action Bar Wajib:
      appBar: AppBar(
        title: const Text("Inventaris Bahan Abimart"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final item = _products[index];
          return Card(
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(
                "Rp ${item['price']} | Stok: ${item['quantity']}\nExp: ${item['expired_date']}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditProductScreen(product: item),
                      ),
                    ).then((_) => _refresh()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEditProductScreen()),
        ).then((_) => _refresh()),
      ),
    );
  }
}
