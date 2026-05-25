import '../tour_image/tour_image.dart';
import '../tour_instance/tour_instance.dart';

/// Tour model - represents a tour package
class Tour {
  const Tour({
    this.id,
    required this.name,
    this.description,
    required this.pricePerAdult,
    required this.pricePerChild,
    this.averageRating = 0.0,
    this.ratingCount = 0,
    this.startLocation = '',
    this.durationDays = 0,
    this.images,
    this.instances,
  });

  final String? id;
  final String name;
  final String? description;
  final double pricePerAdult;
  final double pricePerChild;
  final double averageRating;
  final int ratingCount;
  final String startLocation;
  final int durationDays;
  final List<TourImage>? images;
  final List<TourInstance>? instances;

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      pricePerAdult: (json['pricePerAdult'] as num?)?.toDouble() ?? 0.0,
      pricePerChild: (json['pricePerChild'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      startLocation: json['startLocation'] as String? ?? '',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => TourImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      instances: (json['instances'] as List<dynamic>?)
          ?.map((e) => TourInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
