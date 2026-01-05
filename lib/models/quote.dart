import 'package:hive_flutter/hive_flutter.dart';

part 'quote.g.dart';

@HiveType(typeId: 2)
class Quote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final DateTime createdAt;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.createdAt,
  });
}
