class Product {
  String? id;
  String name;
  String category;
  int stock;
  int sellingPrice;
  int basicPrice;
  int quantity;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.sellingPrice,
    required this.basicPrice,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'stock': stock,
      'sellingPrice': sellingPrice,
      'basicPrice': basicPrice,
      'quantity': quantity,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String,
      category: json['category'] as String,
      stock: json['stock'] as int,
      sellingPrice: json['sellingPrice'] as int,
      basicPrice: json['basicPrice'] as int,
      quantity: json['quantity'] as int? ?? 0,
    );
  }
  Product copyWith({
    String? id,
    String? name,
    String? category,
    int? stock,
    int? sellingPrice,
    int? basicPrice,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      basicPrice: basicPrice ?? this.basicPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
