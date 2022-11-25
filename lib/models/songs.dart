import 'package:hive_flutter/adapters.dart';
part 'songs.g.dart';

@HiveType(typeId: 0)
class Songs extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String uri;

  @HiveField(4)
  int count;
  Songs({
    required this.id,
    required this.title,
    required this.artist,
    required this.uri,
    this.count = 0,
  });
}
