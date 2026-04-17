import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/task.dart';

class ModernTaskCard extends StatelessWidget {
  final Task task;
  final bool isSaving;

  final List<Color> statusColors = const [
    Color(0xFF00B4FF),
    Color(0xFFFF3B30),
    Color(0xFFFFCC00),
    Color(0xFF34C759),
  ];

  ModernTaskCard({required this.task, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    final borderColor = statusColors[task.indicatorToMoId % statusColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Draggable<Task>(
        data: task,
        feedback: Transform.rotate(
          angle: 0.04,
          child: Material(
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF006591), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: _buildContent(borderColor),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.2,
          child: _buildCardContainer(borderColor),
        ),
        child: _buildCardContainer(borderColor),
      ),
    );
  }

  Widget _buildCardContainer(Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF29343A).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: _buildContent(borderColor),
    );
  }

  Widget _buildContent(Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: borderColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'ID: ${task.indicatorToMoId}',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: borderColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          task.name,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF29343A),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 14, color: const Color(0xFF566168).withOpacity(0.5)),
                const SizedBox(width: 4),
                Text('0', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF566168).withOpacity(0.7))),
              ],
            ),
            Icon(Icons.more_horiz, size: 16, color: const Color(0xFF566168).withOpacity(0.5)),
          ],
        )
      ],
    );
  }
}