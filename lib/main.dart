import 'package:admin/constants.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:admin/ohs/controllers/ohs_dashboard_controller.dart';
import 'package:admin/ohs/data/api_atestado_repository.dart';
import 'package:admin/ohs/data/hybrid_atestado_repository.dart';
import 'package:admin/ohs/data/in_memory_atestado_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard • Saúde do Trabalho',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MenuAppController(),
          ),
          ChangeNotifierProvider(
            create: (_) {
              final local = InMemoryAtestadoRepository.seeded();
              final api = ApiAtestadoRepository();
              final repo = HybridAtestadoRepository(api: api, local: local);

              final controller = OhsDashboardController(repository: repo);
              controller.initialize(); // carrega dados
              return controller;
            },
          ),
        ],
        child: const MainScreen(),
      ),
    );
  }
}
