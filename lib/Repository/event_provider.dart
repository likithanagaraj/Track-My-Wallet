import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/eventModel.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  EventProvider() {
    loadFromHive();
  }

  void loadFromHive() {
    final box = Hive.box<EventModel>('events');
    _events = box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  void addEvent(EventModel event) {
    final box = Hive.box<EventModel>('events');
    box.put(event.id, event);
    loadFromHive();
  }

  void updateEvent(EventModel event) {
    final box = Hive.box<EventModel>('events');
    box.put(event.id, event);
    loadFromHive();
  }

  void deleteEvent(String id) {
    final box = Hive.box<EventModel>('events');
    box.delete(id);
    loadFromHive();
  }

  EventModel? getEventById(String? id) {
    if (id == null) return null;
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
