import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/osmangazi_toplanma_alanlari.dart';
import '../data/nilufer_toplanma_alanlari.dart';
import '../data/mudanya_toplanma_alanlari.dart';
import '../models/toplanma_alani.dart';

final toplanmaAlanlariProvider = Provider<List<ToplanmaAlani>>((ref) => [
  ...osmangaziToplanmaAlanlari.map((e) => ToplanmaAlani(
    ilce: 'Osmangazi', mahalle: e['mahalle'], ad: e['ad'],
    enlem: e['enlem'], boylam: e['boylam'], alanM2: e['alan_m2'])),
  ...niluferToplanmaAlanlari.map((e) => ToplanmaAlani(
    ilce: 'Nilüfer', mahalle: '', ad: e['ad'],
    enlem: e['enlem'], boylam: e['boylam'])),
  ...mudanyaToplanmaAlanlari.map((e) => ToplanmaAlani(
    ilce: 'Mudanya', mahalle: e['mahalle'], ad: e['ad'],
    enlem: e['enlem'], boylam: e['boylam'])),
]);

final seciliIlceProvider = StateProvider<String>((ref) => 'Tümü');