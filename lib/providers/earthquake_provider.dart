import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/earthquake.dart';

final earthquakesProvider = FutureProvider<List<Earthquake>>((ref) async {
  final url = Uri.parse('https://api.orhanaydogdu.com.tr/deprem/kandilli/live');
  
  final res = await http.get(url, headers: {'accept': 'application/json'});
  if (res.statusCode != 200) throw Exception('API ${res.statusCode}');

  final data = json.decode(res.body);
  final List list = data['result'] ?? [];

  return list.map((e) => Earthquake.fromKandilli(e)).toList();
});