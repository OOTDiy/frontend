import 'dart:io';
import 'package:flutter/material.dart';

class CanvasActionsManager {
  final List<List<Map<String, dynamic>>> _history = [];
  final List<List<Map<String, dynamic>>> _redoStack = [];

  List<List<Map<String, dynamic>>> get history => List.from(_history);

  void save(List<Map<String, dynamic>> currentState) {
    final copiedState = currentState.map((item) => {
      'image': item['image'],
      'offset': Offset(item['offset'].dx, item['offset'].dy),
      'key': UniqueKey(),
    }).toList();

    _history.add(copiedState);
    _redoStack.clear(); // reset redo
  }

  List<Map<String, dynamic>> undo() {
    if (_history.length > 1) {
      final last = _history.removeLast();
      _redoStack.add(last);
      return _deepCopy(_history.last);
    } else if (_history.length == 1) {
      _redoStack.add(_history.removeLast());
      return [];
    }
    return [];
  }

  List<Map<String, dynamic>> redo() {
    if (_redoStack.isNotEmpty) {
      final restored = _redoStack.removeLast();
      _history.add(restored);
      return _deepCopy(restored);
    }
    return [];
  }

  List<Map<String, dynamic>> reload(List<Map<String, dynamic>> current) {
    _history.clear();
    _redoStack.clear();
    return current;
  }

  List<Map<String, dynamic>> _deepCopy(List<Map<String, dynamic>> state) {
    return state.map((item) => {
      'image': item['image'],
      'offset': Offset(item['offset'].dx, item['offset'].dy),
      'key': UniqueKey(),
    }).toList();
  }
}
