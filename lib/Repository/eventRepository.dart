import 'package:uuid/uuid.dart';
import '../model/eventModel.dart';

class EventRepository {
  final _uuid = const Uuid();

  EventModel create({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    double? budget,
  }) {
    return EventModel(
      id: _uuid.v4(),
      name: name,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      createdAt: DateTime.now(),
      budget: budget,
    );
  }
}
