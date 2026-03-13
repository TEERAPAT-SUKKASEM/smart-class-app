import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/class_record.dart';

class StorageService {
  static const String _key = 'class_records';

  Future<void> saveRecord(ClassRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_key) ?? [];

    existing.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_key, existing);
    print("Record Saved Successfully!");
  }
}
