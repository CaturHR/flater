/// Model class yang merepresentasikan data Item dari API.
///
/// Digunakan untuk memetakan data JSON dari REST API
/// ke dalam objek Dart yang mudah digunakan.
class ItemModel {
  final int? id;
  final String name;
  final String description;

  /// Constructor utama
  ItemModel({
    this.id,
    required this.name,
    required this.description,
  });

  /// Factory constructor untuk membuat ItemModel dari JSON response API.
  ///
  /// API JSONPlaceholder menggunakan field 'title' dan 'body',
  /// yang dimapping ke 'name' dan 'description'.
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int?,
      name: json['title'] as String? ?? '',
      description: json['body'] as String? ?? '',
    );
  }

  /// Konversi ItemModel ke Map untuk dikirim ke API via POST/PUT.
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'body': description,
    };
  }

  /// Method copyWith untuk membuat salinan dengan perubahan tertentu.
  /// Berguna untuk immutability saat update data.
  ItemModel copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => 'ItemModel(id: $id, name: $name, description: $description)';
}
