class Movie {
  final String name;
  final String image;
  final String duration;
  final String url;
  final String type;

  Movie({
    required this.name,
    required this.image,
    required this.duration,
    required this.url,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'duration': duration,
      'url': url,
      'type': type,

    };
  }
}