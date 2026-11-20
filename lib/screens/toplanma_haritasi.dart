import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/toplanma_provider.dart';

class ToplanmaHaritasi extends ConsumerStatefulWidget {
  const ToplanmaHaritasi({super.key});
  @override ConsumerState<ToplanmaHaritasi> createState() => _State();
}

class _State extends ConsumerState<ToplanmaHaritasi> {
  final _mapController = MapController();
  LatLng? _konumum;

  @override
  void initState() {
    super.initState();
    _konumuAl();
  }

  Future<void> _konumuAl() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.deniedForever) return;
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final yeni = LatLng(pos.latitude, pos.longitude);
      setState(() => _konumum = yeni);
      _mapController.move(yeni, 15);
    } catch (_) {}
  }

  void _zoomIn() {
    final zoom = _mapController.camera.zoom + 1;
    _mapController.move(_mapController.camera.center, zoom.clamp(3, 18));
  }

  void _zoomOut() {
    final zoom = _mapController.camera.zoom - 1;
    _mapController.move(_mapController.camera.center, zoom.clamp(3, 18));
  }

  @override
  Widget build(BuildContext context) {
    final tumu = ref.watch(toplanmaAlanlariProvider);
    final ilce = ref.watch(seciliIlceProvider);
    final alanlar = ilce == 'Tümü' ? tumu : tumu.where((a) => a.ilce == ilce).toList();

    final markers = <Marker>[
      ...alanlar.map((a) => Marker(
        point: LatLng(a.enlem, a.boylam),
        width: 40, height: 40,
        child: const Icon(Icons.location_on, color: Colors.red, size: 36),
      )),
      if (_konumum != null)
        Marker(
          point: _konumum!,
          width: 50, height: 50,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 42),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toplanma Alanları'),
        actions: [
          DropdownButton<String>(
            value: ilce,
            underline: const SizedBox(),
            dropdownColor: Colors.grey.shade900,
            style: const TextStyle(color: Colors.white),
            items: ['Tümü','Osmangazi','Nilüfer','Mudanya']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => ref.read(seciliIlceProvider.notifier).state = v!,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _konumum ?? const LatLng(40.19, 29.06),
              initialZoom: _konumum == null ? 12 : 15,
            ),
            children: [
             TileLayer(
             urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
             userAgentPackageName: 'com.afetradar.app',
     ),
              MarkerLayer(markers: markers),
            ],
          ),
          // Zoom tuşları sağ üstte
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'my_loc',
        onPressed: _konumuAl,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}