import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/kanban_provider.dart';
import '../widgets/kanban_column.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key});

  final Color bgMain = const Color(0xFFF5F7FA);
  final Color textPrimary = const Color(0xFF29343A);
  final Color textSecondary = const Color(0xFF566168);
  final Color primaryColor = const Color(0xFF006591);

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final navBarHeight = 64.0;
    final boardHeight = screenHeight - navBarHeight;

    return Scaffold(
      backgroundColor: bgMain,
      body: Column(
        children: [
          // 1. TOP NAVBAR (Fixe en haut)
          Container(
            height: navBarHeight,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.view_kanban, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Kanban Board', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary)),
                const Spacer(),

                Container(
                  width: 250,
                  height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFE8EFF4), borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    enabled: true, // Corrigé ici
                    style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                    onChanged: (value) => context.read<KanbanProvider>().updateSearch(value),
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                      prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const CircleAvatar(radius: 16, backgroundColor: Colors.blue),
                const SizedBox(width: 24),
              ],
            ),
          ),


          Expanded(
            child: Consumer<KanbanProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return  Center(child: CircularProgressIndicator(color: primaryColor));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    height: boardHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.columnIds.map((colId) {
                        return KanbanColumn(
                          columnId: colId,
                          columnName: provider.getColumnName(colId),
                          tasks: provider.columns[colId] ?? [],
                          isSaving: provider.isSaving,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}



