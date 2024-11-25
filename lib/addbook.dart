
import 'package:flutter/material.dart';
import 'package:perpustakaan/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Addbook extends StatefulWidget {
  const Addbook({super.key});
  @override
  _AddbookState createState() => _AddbookState();
}

class _AddbookState extends State<Addbook> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController penulisController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  Future<void> createBook() async {
    if (formKey.currentState!.validate()) {
      final response = await Supabase.instance.client.from('Buku').insert({
        'judul': judulController.text,
        'penulis': penulisController.text,
        'deskripsi': deskripsiController.text,
      });

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Buku telah ditambahkan'),
        ));
        Navigator.pop(context,true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BookListPage()));
        print(response);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menambahkan buku: ${response.error!.message}'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Buku')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextFormField(
                controller: penulisController,
                decoration: const InputDecoration(labelText: 'Penulis'),
              ),
              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: createBook, child: Text('Simpan'))
            ],
          ),
        ),
      ),
    );
  }
}
