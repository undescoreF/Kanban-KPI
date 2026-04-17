import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../data/models/task.dart';
import '../providers/kanban_provider.dart';
import 'task_card.dart';

class KanbanColumn extends StatefulWidget {
  final int columnId;
  final String columnName;
  final List<Task> tasks;
  final bool isSaving;
  final Color textPrimary;
  final Color textSecondary;

  const KanbanColumn({
    required this.columnId,
    required this.columnName,
    required this.tasks,
    required this.isSaving,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KanbanProvider>();

    final filteredTasks = provider.searchQuery.isEmpty
        ? widget.tasks
        : widget.tasks.where((task) => task.name.toLowerCase().contains(provider.searchQuery)).toList();

    if (filteredTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Text(widget.columnName, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15, color: widget.textPrimary)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE8EFF4), borderRadius: BorderRadius.circular(12)),
                  child: Text(filteredTasks.length.toString(), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 11, color: widget.textSecondary)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(filteredTasks.length, (index) {
                    final task = filteredTasks[index];

                    return DragTarget<Task>(
                      key: ValueKey('target_${task.indicatorToMoId}'),
                      onWillAcceptWithDetails: (_) => !widget.isSaving,
                      onAcceptWithDetails: (details) {

                        provider.moveTask(details.data, widget.columnId, index, context);
                      },
                      builder: (context, candidateData, rejectedData) {
                        bool isHovering = candidateData.isNotEmpty;
                        return Column(
                          children: [
                            if (isHovering)
                              Container(height: 4, margin: const EdgeInsets.only(bottom: 4), decoration: BoxDecoration(color: const Color(0xFF006591).withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
                            ModernTaskCard(task: task, isSaving: widget.isSaving),
                          ],
                        );
                      },
                    );
                  }),


                  DragTarget<Task>(
                    onWillAcceptWithDetails: (_) => !widget.isSaving,
                    onAcceptWithDetails: (details) {
                      provider.moveTask(details.data, widget.columnId, filteredTasks.length, context);
                    },
                    builder: (context, candidateData, rejectedData) {
                      bool isHovering = candidateData.isNotEmpty;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(top: 8),
                        height: 40,
                        decoration: BoxDecoration(
                          color: isHovering ? const Color(0xFF006591).withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isHovering ? Border.all(color: const Color(0xFF006591).withOpacity(0.3), width: 2, strokeAlign: BorderSide.strokeAlignOutside) : null,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}