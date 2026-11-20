class Earthquake {
  final String place;
  final double mag;
  final double depth;
  final DateTime time;
  final double lat;
  final double lng;
  final String id;

  Earthquake({
    required this.place,
    required this.mag,
    required this.depth,
    required this.time,
    required this.lat,
    required this.lng,
    required this.id,
  });

  factory Earthquake.fromKandilli(Map<String, dynamic> e) {
    // API geojson: { "coordinates": [lng, lat] }
    double lat = 0.0;
    double lng = 0.0;

    final geo = e['geojson'];
    if (geo!= null && geo['coordinates'] is List) {
      final coords = geo['coordinates'] as List;
      if (coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    }

    // date format: "2025-05-20 11:07:34"
    DateTime time;
    try {
      time = DateTime.parse(e['date'].toString().replaceFirst(' ', 'T'));
    } catch (_) {
      time = DateTime.now();
    }

    return Earthquake(
      id: e['earthquake_id']?.toString()?? '',
      place: e['title']?.toString()?? 'Bilinmeyen',
      mag: (e['mag'] as num?)?.toDouble()?? 0.0,
      depth: (e['depth'] as num?)?.toDouble()?? 0.0,
      time: time,
      lat: lat,
      lng: lng,
    );
  }
}