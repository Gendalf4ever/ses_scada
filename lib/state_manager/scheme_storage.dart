import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/saved_scheme_model.dart';

class SchemeStorage {
  static final SchemeStorage _instance = SchemeStorage._internal();
  factory SchemeStorage() => _instance;
  SchemeStorage._internal();

  final List<SavedSchemeModel> _schemes = [];

  List<SavedSchemeModel> get schemes => List.unmodifiable(_schemes);

  //paths

  Future<Directory> _getSchemesDir() async {
    final baseDir = await getApplicationSupportDirectory();
    final schemesDir = Directory('${baseDir.path}/schemes');

    if (!await schemesDir.exists()) {
      await schemesDir.create(recursive: true);
    }

    return schemesDir;
  }

  File _schemeFile(Directory dir, SavedSchemeModel scheme) {
    final safeName = scheme.name.replaceAll(RegExp(r'[^\w\-]+'), '_');
    return File('${dir.path}/scheme_$safeName.json');
  }

  //load

  Future<void> load() async {
    _schemes.clear();

    try {
      final dir = await _getSchemesDir();
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'));

      for (final file in files) {
        try {
          final jsonStr = await file.readAsString();
          if (jsonStr.trim().isEmpty) continue;

          final data = jsonDecode(jsonStr);
          final scheme = SavedSchemeModel.fromJson(data);

          _schemes.add(scheme);
        } catch (e, st) {
          debugPrint('Failed to load scheme: ${file.path}');
          debugPrint('$e');
          debugPrintStack(stackTrace: st);
        }
      }
    } catch (e, st) {
      debugPrint('SchemeStorage load error');
      debugPrint('$e');
      debugPrintStack(stackTrace: st);
    }
  }

  //save

  Future<void> addScheme(SavedSchemeModel scheme) async {
    _schemes.add(scheme);
    await _saveScheme(scheme);
  }

  Future<void> updateScheme(SavedSchemeModel scheme) async {
    await _saveScheme(scheme);
  }

  Future<void> deleteScheme(SavedSchemeModel scheme) async {
    final dir = await _getSchemesDir();
    final file = _schemeFile(dir, scheme);

    if (await file.exists()) {
      await file.delete();
    }

    _schemes.remove(scheme);
  }

  Future<void> _saveScheme(SavedSchemeModel scheme) async {
    final dir = await _getSchemesDir();
    final file = _schemeFile(dir, scheme);

    final jsonStr = jsonEncode(scheme.toJson());
    await file.writeAsString(jsonStr);
  }
}
