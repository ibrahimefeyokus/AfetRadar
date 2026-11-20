import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final koyuTemaProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final koyu = ref.watch(koyuTemaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          // BİLDİRİM SATIRI KALDIRILDI
          SwitchListTile(
            title: const Text('Koyu Tema'),
            value: koyu,
            onChanged: (v) => ref.read(koyuTemaProvider.notifier).state = v,
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Konum İzni'),
            subtitle: FutureBuilder(
              future: Geolocator.checkPermission(),
              builder: (_, s) => Text(s.data?.toString().split('.').last ?? 'bilinmiyor'),
            ),
            onTap: () => Geolocator.openAppSettings(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Bildirimler'),
            subtitle: const Text('Yakında: anlık push desteği eklenecek'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('AfetRadar v1.0.0'),
            subtitle: const Text('Bursa Toplanma Alanları 441 adet'),
          ),
        ],
      ),
    );
  }
}