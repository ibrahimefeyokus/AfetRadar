import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/toplanma_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alanlar = ref.watch(toplanmaAlanlariProvider);
    final ilce = ref.watch(seciliIlceProvider);

    final filtreli = ilce == 'Tümü' 
        ? alanlar 
        : alanlar.where((a) => a.ilce == ilce).toList();

    final markers = filtreli.map((a) => Marker(
      point: LatLng(a.enlem, a.boylam),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.ad, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${a.ilce} / ${a.mahalle}'.trim()),
                if (a.alanM2 != null) 
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Alan: ${a.alanM2} m²'),
                  ),
              ],
            ),
          ),
        ),
        child: const Icon(Icons.location_on, color: Colors.red, size: 36),
      ),
    )).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Toplanma Alanları (${filtreli.length})'),
        backgroundColor: Colors.red.shade700,
        actions: [
          DropdownButton<String>(
            value: ilce,
            underline: const SizedBox(),
            dropdownColor: Colors.red.shade700,
            style: const TextStyle(color: Colors.white),
            items: ['Tümü','Osmangazi','Nilüfer','Mudanya']
                .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => ref.read(seciliIlceProvider.notifier).state = v!,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(40.195, 29.06), // Bursa merkez
          initialZoom: 12,
          minZoom: 10,
          maxZoom: 18,
        ),
        children: [
          // CARTO - OSM ban'ı yok
          TileLayer(
            urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.afetradar.app',
            maxZoom: 19,
          ),
          MarkerLayer(markers: markers),
          // Küçük attribution
          const RichAttributionWidget(
            attributions: [
              TextSourceAttribution('© CARTO'),
              TextSourceAttribution('© OpenStreetMap'),
            ],
          ),
        ],
      ),
    );
  }
}