class SliderImage {
  final String id;
  final String imageName;
  final String imageData;
  final String createdAt;

  const SliderImage({
    required this.id,
    required this.imageName,
    required this.imageData,
    required this.createdAt,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json) => SliderImage(
        id: json['id'].toString(),
        imageName: json['image_name'] ?? '',
        imageData: json['image_data'] ?? '',
        createdAt: json['created_at'] ?? '',
      );
}
