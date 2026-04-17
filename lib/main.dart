import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';

import 'features/ kanban_board/providers/kanban_provider.dart';
import 'features/ kanban_board/screens/kanban_board_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const KpiKanbanApp());
}

class KpiKanbanApp extends StatelessWidget {
  const KpiKanbanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KanbanProvider()..loadTasks()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KPI Drive Kanban',
        theme: AppTheme.lightTheme,
        home: const KanbanBoardScreen(),
      ),
    );
  }
}