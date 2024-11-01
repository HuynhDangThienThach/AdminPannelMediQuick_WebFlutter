class ProductAttributeModel {
  String? name;
  final List<String>? values;

  ProductAttributeModel({this.name, this.values});

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Values': values,
    };
  }

  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    return ProductAttributeModel(
      name: document['Name'] as String?,
      values: List<String>.from(document['Values'] ?? []),
    );
  }
}
