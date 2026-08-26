import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: HomePage()));

final List<Map<String, dynamic>> buku = [
  {'judul':'Laskar Pelangi','pengarang':'Andrea Hirata','tahun':2005,'rating':4.7,'tersedia':true,'genre':'Drama'},
  {'judul':'Bumi Manusia','pengarang':'Pramoedya','tahun':1980,'rating':4.8,'tersedia':false,'genre':'Sejarah'},
  {'judul':'Filosofi Teras','pengarang':'Henry M','tahun':2018,'rating':4.5,'tersedia':true,'genre':'Self-Help'},
  {'judul':'Pulang','pengarang':'Tere Liye','tahun':2015,'rating':4.2,'tersedia':true,'genre':'Drama'},
  {'judul':'Atomic Habits','pengarang':'James Clear','tahun':2018,'rating':4.9,'tersedia':false,'genre':'Self-Help'},
  {'judul':'Sang Pemimpi','pengarang':'Andrea Hirata','tahun':2006,'rating':3.2,'tersedia':true,'genre':'Novel'},
];

String kategoriRating(double r) {
  if (r >= 4.5) return 'Sangat Baik';
  if (r >= 3.5) return 'Baik';
  return 'Cukup';
}

class HomePage extends StatefulWidget {
  @override _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String q = '';
  Set<String> get genre => buku.map((b) => b['genre'] as String).toSet();
  List get filter => buku.where((b) => (b['judul'] as String).toLowerCase().contains(q.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Daftar Buku')),
    body: Padding(padding: EdgeInsets.all(8), child: Column(children: [
      TextField(decoration: InputDecoration(labelText: 'Cari judul', border: OutlineInputBorder()), onChanged: (v) => setState(() => q = v)),
      SizedBox(height: 8),
      Wrap(spacing: 6, children: genre.map((g) => Chip(label: Text(g))).toList()),
      SizedBox(height: 8),
      Expanded(child: ListView.builder(
        itemCount: filter.length,
        itemBuilder: (_, i) {
          var b = filter[i]; var ada = b['tersedia'] as bool;
          return Card(child: ListTile(
            title: Text(b['judul']),
            subtitle: Text("${b['pengarang']} • ${b['tahun']} • ${b['rating']} (${kategoriRating(b['rating'])})"),
            trailing: Chip(label: Text(ada ? 'Tersedia' : 'Dipinjam'), backgroundColor: ada ? Colors.green : Colors.red, labelStyle: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(buku: b))),
          ));
        },
      )),
    ])),
  );
}

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> buku;
  DetailPage({required this.buku});
  @override _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {
  String? catatan;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.buku['judul'])),
    body: Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Pengarang: ${widget.buku['pengarang']}"),
      Text("Tahun: ${widget.buku['tahun']}"),
      Text("Rating: ${widget.buku['rating']} (${kategoriRating(widget.buku['rating'])})"),
      Text("Genre: ${widget.buku['genre']}"),
      Divider(), Text("Catatan Peminjam:", style: TextStyle(fontWeight: FontWeight.bold)),
      Text(catatan ?? '(Tidak ada catatan)'),
      ElevatedButton(onPressed: () => setState(() => catatan = 'Dikembalikan.'), child: Text('Tambah Catatan')),
    ])),
  );
}