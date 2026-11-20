import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Deprem {
  final String tarih, saat, yer;
  final double enlem, boylam, derinlik, buyukluk;
  Deprem({required this.tarih, required this.saat, required this.yer, required this.enlem, required this.boylam, required this.derinlik, required this.buyukluk});
}

final depremProvider = FutureProvider<List<Deprem>>((ref) async {
  final url = Uri.parse('https://api.orhanaydogdu.com.tr/deprem/kandilli/live');
  final res = await http.get(url);
  final data = json.decode(res.body)['result'] as List;
  return data.map((e) => Deprem(
    tarih: e['date'],
    saat: e['time'],
    yer: e['title'],
    enlem: double.parse(e['lat'].toString()),
    boylam: double.parse(e['lng'].toString()),
    derinlik: double.parse(e['depth'].toString()),
    buyukluk: double.parse(e['mag'].toString()),
  )).toList();
});