import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perpustakaan/addbook.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> buku = [];
  int? hoveredIndex; // Untuk melacak indeks yang sedang di-hover

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('Buku').select();

    setState(() {
      buku = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 10,
        centerTitle: true,
        title: Text(
          'Daftar buku',
          style: GoogleFonts.lora(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: fetchBooks, icon: const Icon(Icons.refresh))
        ],
      ),
      body: buku.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: buku.length,
              itemBuilder: (context, index) {
                final book = buku[index];

                return Card(
                  elevation: 5,
                  child: InkWell(
                    onHover: (hovering) {
                      setState(() {
                        hoveredIndex = hovering ? index : null;
                      });
                    },
                    onTap: () {
                      // Aksi jika ListTile diklik
                      // print('Tile ${book['judul']} diklik!');
                    },
                    child: ListTile(
                      tileColor: hoveredIndex == index
                          ? Colors.grey[300]
                          : Colors.white, // Warna saat di-hover
                      isThreeLine: true,
                      title: Text(
                        book['judul'] ?? 'No title',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book['penulis'] ?? 'No Author',
                            style: const TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            book['deskripsi'] ?? 'No description',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Addbook()),);
      },child: const Icon(Icons.add),),
    );
  }
}
