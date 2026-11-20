import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/earthquake_provider.dart';

class EarthquakesScreen extends ConsumerWidget {
  const EarthquakesScreen({super.key});

  Color _magColor(double mag) {
    if (mag >= 5) return Colors.red;
    if (mag >= 4) return Colors.orange;
    if (mag >= 3) return Colors.amber;
    return Colors.green;
  }

  // ESKİ Kandilli linki yerine AFAD
  Future<void> _openAfad() async {
    final url = Uri.parse('https://deprem.afad.gov.tr/last-earthquakes.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openMap(double lat, double lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quakes = ref.watch(earthquakesProvider);
    final dateFormat = DateFormat('dd MMM HH:mm', 'tr_TR');

    return Scaffold(
      appBar: AppBar(title: const Text('Son Depremler')),
      body: quakes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(earthquakesProvider.future),
          child: ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final q = list[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _magColor(q.mag),
                  child: Text(q.mag.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                title: Text(q.place, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${dateFormat.format(q.time)} • ${q.depth.toStringAsFixed(1)} km'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _magColor(q.mag),
                                radius: 24,
                                child: Text(q.mag.toStringAsFixed(1),
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(q.place,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          _detailRow('Tarih', dateFormat.format(q.time)),
                          _detailRow('Derinlik', '${q.depth.toStringAsFixed(1)} km'),
                          _detailRow('Enlem', q.lat.toStringAsFixed(4)),
                          _detailRow('Boylam', q.lng.toStringAsFixed(4)),
                          _detailRow('Kaynak', 'AFAD / Kandilli'),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text('Haritada Aç'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () => _openMap(q.lat, q.lng),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.open_in_browser),
                              label: const Text('AFAD Son Depremler'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _openAfad,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}