class Product {
  final String product_name;
  final String product_detail;
  final int price;
  final String image;
  final String public_id;
  final String id;


  Product(
      {required this.product_name,
      required this.product_detail,
      required this.price,
      required this.image,
      required this.public_id,
      required this.id
      });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        product_name: json['product_name'] ?? '',
        product_detail: json['product_detail'] ?? '',
        price: json['price'] ?? '',
        public_id: json['public_id'] ?? '',
        image: json['image'] ?? '',
        id: json['_id'] ?? ''
    );
  }
}
