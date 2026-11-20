import '../../data/mudanya_toplanma_alanlari.dart';
import '../../data/nilufer_toplanma_alanlari.dart';
import '../../data/osmangazi_toplanma_alanlari.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/toplanma_provider.dart';

final aileUyeleriProvider = StreamProvider((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonim';
  return FirebaseFirestore.instance
      .collection('users').doc(uid).collection('aile')
      .snapshots();
});

class FamilyPlanScreen extends ConsumerWidget {
  const FamilyPlanScreen({super.key});

  Future<void> _iyimGonder(List<QueryDocumentSnapshot> uyeler) async {
    const mesaj = 'AfetRadar: İyiyim, belirlediğimiz toplanma alanına gidiyorum.';
    for (final u in uyeler) {
      final tel = (u['telefon'] ?? '').toString().replaceAll(RegExp(r'\D'), '');
      if (tel.isEmpty) continue;
      final wa = Uri.parse('https://wa.me/90$tel?text=${Uri.encodeComponent(mesaj)}');
      if (await canLaunchUrl(wa)) {
        await launchUrl(wa, mode: LaunchMode.externalApplication);
      } else {
        final sms = Uri.parse('sms:$tel?body=${Uri.encodeComponent(mesaj)}');
        await launchUrl(sms);
      }
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aile = ref.watch(aileUyeleriProvider);
    final alanlar = ref.watch(toplanmaAlanlariProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ailem')),
      body: aile.when(
        data: (snap) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: snap.docs.map((d) {
                  final data = d.data() as Map;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(data['ad'] ?? ''),
                      subtitle: Text('${data['telefon'] ?? ''}\nBuluşma: ${data['alan'] ?? 'Seçilmedi'}'),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Aile Üyesi Ekle'),
                    onPressed: () => _uyeEkle(context, alanlar),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('İYİYİM - Tüm Aileye Gönder'),
                    onPressed: snap.docs.isEmpty ? null : () => _iyimGonder(snap.docs),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }

  void _uyeEkle(BuildContext context, List alanlar) {
    final adCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    String? seciliAlan;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Yeni Üye'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: adCtrl, decoration: const InputDecoration(labelText: 'Ad Soyad')),
              TextField(controller: telCtrl, decoration: const InputDecoration(labelText: 'Telefon 5xx'), keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              DropdownButton<String>(
                hint: const Text('Buluşma Alanı'),
                isExpanded: true,
                value: seciliAlan,
                menuMaxHeight: 400,
                // DÜZELTME: .take(50) kaldırıldı - tüm alanlar geliyor
                items: alanlar.map<DropdownMenuItem<String>>((a) =>
                  DropdownMenuItem<String>(
                    value: a.ad,
                    child: Text(a.ad, overflow: TextOverflow.ellipsis),
                  )
                ).toList(),
                onChanged: (v) => setSt(() => seciliAlan = v),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            FilledButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonim';
                await FirebaseFirestore.instance.collection('users').doc(uid).collection('aile').add({
                  'ad': adCtrl.text,
                  'telefon': telCtrl.text,
                  'alan': seciliAlan,
                  'eklenme': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}