import 'dart:convert';

/// Data model for a hospital / PHC record stored in SQLite.
class Hospital {
  final int? id;
  final String name;
  final String type;
  final double lat;
  final double lng;
  final String? address;
  final String? phone;
  final String? district;
  final List<String> services;
  final bool emergencyCapable;
  final int? beds;
  final int? lastSynced;

  const Hospital({
    this.id,
    required this.name,
    required this.type,
    required this.lat,
    required this.lng,
    this.address,
    this.phone,
    this.district,
    this.services = const [],
    this.emergencyCapable = false,
    this.beds,
    this.lastSynced,
  });

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
      address: map['address'] as String?,
      phone: map['phone'] as String?,
      district: map['district'] as String?,
      services: map['services'] != null
          ? List<String>.from(jsonDecode(map['services'] as String))
          : [],
      emergencyCapable: (map['emergency_capable'] as int? ?? 0) == 1,
      beds: map['beds'] as int?,
      lastSynced: map['last_synced'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      'lat': lat,
      'lng': lng,
      'address': address,
      'phone': phone,
      'district': district,
      'services': jsonEncode(services),
      'emergency_capable': emergencyCapable ? 1 : 0,
      'beds': beds,
      'last_synced': lastSynced,
    };
  }

  Hospital copyWith({
    int? id,
    String? name,
    String? type,
    double? lat,
    double? lng,
    String? address,
    String? phone,
    String? district,
    List<String>? services,
    bool? emergencyCapable,
    int? beds,
    int? lastSynced,
  }) {
    return Hospital(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      district: district ?? this.district,
      services: services ?? this.services,
      emergencyCapable: emergencyCapable ?? this.emergencyCapable,
      beds: beds ?? this.beds,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  @override
  String toString() => 'Hospital($id, $name, $type)';
}
