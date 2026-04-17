import 'package:flutter/material.dart';

import '../../../data/models/task.dart';
import '../../../data/services/api_service.dart';


class KanbanProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = true;
  bool isSaving = false;
  String? error;
  String searchQuery = '';

  Map<int, List<Task>> columns = {};
  List<int> columnIds = [];

  final Map<int, String> columnNames = {
    4255: 'Бэклог',
    318198: 'В работе',
    318201: 'Тестирование',
    318202: 'Готово',
  };

  String getColumnName(int id) => columnNames[id] ?? 'Папка $id';

  void updateSearch(String query) {
    searchQuery = query.toLowerCase();
    notifyListeners();
  }

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();
    try {
      final allTasks = await _apiService.getTasks();
      final allTaskIds = allTasks.map((t) => t.indicatorToMoId).toSet();
      final rootColumnIds = allTasks.map((t) => t.parentId).where((id) => !allTaskIds.contains(id)).toList();

      columns.clear();
      for (var task in allTasks) {
        if (rootColumnIds.contains(task.parentId)) {
          columns.putIfAbsent(task.parentId, () => []).add(task);
        }
      }
      columns.forEach((key, list) => list.sort((a, b) => a.order.compareTo(b.order)));
      columnIds = columns.keys.toList();
    } catch (e) {
      error = 'Erreur de chargement';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> moveTask(Task task, int newParentId, int newIndex, BuildContext context) async {
    if (isSaving) return;

    final oldParentId = task.parentId;
    final oldOrder = task.order;

    int targetOrder = newIndex + 1;


    if (oldParentId == newParentId) {
      final oldIndex = columns[oldParentId]?.indexOf(task) ?? -1;
      if (oldIndex < newIndex) {
        newIndex--;
        targetOrder = newIndex + 1;
      }
    }

    if (oldParentId == newParentId && oldOrder == targetOrder) {
      return;
    }

    isSaving = true;
    notifyListeners();

    columns[oldParentId]?.remove(task);


    if (!columns.containsKey(newParentId)) {
      columns[newParentId] = [];
      columnIds.add(newParentId);
    }


    newIndex = newIndex.clamp(0, columns[newParentId]!.length);
    columns[newParentId]!.insert(newIndex, task);


    for (int i = 0; i < columns[newParentId]!.length; i++) {
      columns[newParentId]![i].order = i + 1;
    }
    task.parentId = newParentId;
    task.order = newIndex + 1;

    notifyListeners();

    try {
      await _apiService.saveTask(
        indicatorToMoId: task.indicatorToMoId,
        newParentId: newParentId,
        newOrder: task.order,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF29343A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF34C759)),
                SizedBox(width: 12),
                Text('Task moved successfully', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      await loadTasks();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

}