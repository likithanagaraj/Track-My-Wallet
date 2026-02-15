import 'package:hive/hive.dart';

part 'eventModel.g.dart';

@HiveType(typeId: 3)
class EventModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int iconCodePoint; // Store icon as codepoint for Hive
  
  @HiveField(3)
  final int colorValue; // Store color as ARGB int
  
  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final double? budget;

  const EventModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    required this.createdAt,
    this.budget,
  });
}
