import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Headphone',
      'subtitle': 'JBL Quantum 200',
      'price': 800000,
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDCiBfYwbHsipZRaF4FuEX_ZePvF5kFpDjG7MxHSD7zA&s=10',
      'quantity': 1,
      'likes': 12,
      'isFavorite': false,
      'selected': false,
    },
    {
      'name': 'Laptop Lenovo LOQ15',
      'subtitle': 'LENOVO',
      'price': 16400000,
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkwMynOiE3HZwF5zxA-lPIbHN5ipX0hEcBnaovTdOpug&s=10',
      'quantity': 1,
      'likes': 8,
      'isFavorite': false,
      'selected': false,
    },
    {
      'name': 'Wireless Mouse',
      'subtitle': 'Fantech Helios II Pro',
      'price': 1200000,
      'image': 'https://images.tokopedia.net/img/cache/700/aphluv/1997/1/1/a4e09d7f0e004ba4b7c9c87644e38003~.jpeg.webp',
      'quantity': 1,
      'likes': 5,
      'isFavorite': false,
      'selected': false,
    },
  ];

  int navIndex = 0;
  String? bannerMessage;

  // Interaksi 1: tap pada produk.
  void _toggleSelect(Map<String, dynamic> product) {
    setState(() {
      product['selected'] = !product['selected'];
    });
  }

  // Interaksi 2: double tap.
  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      product['isFavorite'] = !product['isFavorite'];

      if (product['isFavorite']) {
        product['likes']++;
      } else {
        product['likes']--;
      }
    });
  }

  // Interaksi 3: long press.
  void _showSelectedBanner(Map<String, dynamic> product) {
    setState(() {
      bannerMessage = '${product['name']} telah dipilih';
    });
  }

  // Interaksi tombol +/- : untuk mengubah jumlah barang di keranjang.
  void _changeQuantity(Map<String, dynamic> product, int delta) {
    setState(() {
      final newQty = product['quantity'] + delta;
      product['quantity'] = newQty < 0 ? 0 : newQty;
    });
  }

  int get totalItems => products.fold(
      0, (sum, p) => sum + (p['quantity'] as int));

  int get totalPrice => products.fold(
      0, (sum, p) => sum + ((p['quantity'] as int) * (p['price'] as int)));

  String _formatRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buffer.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp$buffer';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Cart',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Belanja lebih mudah setiap hari',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (bannerMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Produk dipilih! $bannerMessage',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => bannerMessage = null),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),

              // Daftar produk
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final bool isFavorite = product['isFavorite'];
                    final bool isSelected = product['selected'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),

                      child: GestureDetector(
                        onTap: () => _toggleSelect(product),
                        onDoubleTap: () => _toggleFavorite(product),
                        onLongPress: () => _showSelectedBanner(product),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, color: Colors.blueGrey, size: 28);
                                },
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    product['subtitle'],
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatRupiah(product['price']),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 3),
                                    Text('${product['likes']}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _changeQuantity(product, -1),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.remove, size: 14, color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 22,
                                      child: Text(
                                        '${product['quantity']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _changeQuantity(product, 1),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.add, size: 14, color: Colors.blue),
                                      ),
                                    ),
                                  ],
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

              // Footer
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black, blurRadius: 6, offset: const Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total ($totalItems produk)',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          Text(
                            _formatRupiah(totalPrice),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bottom navigation
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 6, offset: const Offset(0, -1)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Menu 1: Beranda
              GestureDetector(
                onTap: () => setState(() => navIndex = 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: navIndex == 0 ? Colors.blue : Colors.grey, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      'Beranda',
                      style: TextStyle(fontSize: 10, color: navIndex == 0 ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
              ),

              // Menu 2: Kategori
              GestureDetector(
                onTap: () => setState(() => navIndex = 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.grid_view, color: navIndex == 1 ? Colors.blue : Colors.grey, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      'Kategori',
                      style: TextStyle(fontSize: 10, color: navIndex == 1 ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
              ),

              // Menu 3: Keranjang
              GestureDetector(
                onTap: () => setState(() => navIndex = 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart, color: navIndex == 2 ? Colors.blue : Colors.grey, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      'Keranjang',
                      style: TextStyle(fontSize: 10, color: navIndex == 2 ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
              ),

              // Menu 4: Akun
              GestureDetector(
                onTap: () => setState(() => navIndex = 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, color: navIndex == 3 ? Colors.blue : Colors.grey, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      'Akun',
                      style: TextStyle(fontSize: 10, color: navIndex == 3 ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}