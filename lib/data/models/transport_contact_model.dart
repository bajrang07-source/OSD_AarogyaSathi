import 'dart:convert';

/// Data model for a transport contact stored in SQLite.
class TransportContact {
  final int? id;
  final String name;
  final String type; // ambulance | auto | volunteer | driver
  final String phone;
  final String? area;
  final bool is24x7;
  final String? vehicleType;
  final String? notes;

  const TransportContact({
    this.id,
    required this.name,
    required this.type,
    required this.phone,
    this.area,
    this.is24x7 = false,
    this.vehicleType,
    this.notes,
  });

  factory TransportContact.fromMap(Map<String, dynamic> map) {
    return TransportContact(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      phone: map['phone'] as String,
      area: map['area'] as String?,
      is24x7: (map['is_24x7'] as int? ?? 0) == 1,
      vehicleType: map['vehicle_type'] as String?,
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      'phone': phone,
      'area': area,
      'is_24x7': is24x7 ? 1 : 0,
      'vehicle_type': vehicleType,
      'notes': notes,
    };
  }

  @override
  String toString() => 'TransportContact($id, $name, $type)';
}
