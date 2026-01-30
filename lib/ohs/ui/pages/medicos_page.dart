import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/ohs_dashboard_controller.dart';
import '../widgets/charts.dart';
import '../widgets/ohs_card.dart';
import '../widgets/tables.dart';

class MedicosPage extends StatelessWidget {
  const MedicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OhsDashboardController>();
    final rows = ctrl.medicoAggregates;

    final table = OhsCard(
      title: 'Médicos • Resumo',
      child: MedicoSummaryTable(rows: rows),
    );

    final top10 = rows.take(10).toList();
    final labels = top10.map((e) => e.medicoNome == '—' ? 'Sem médico' : e.medicoNome).toList();
    final values = top10.map((e) => e.atestados).toList();

    final chart = OhsCard(
      title: 'Top 10 • Atestados por Médico',
      child: labels.isEmpty
          ? const SizedBox(height: 220, child: Center(child: Text('Sem dados')))
          : OhsBarChartSingle(labels: labels, values: values),
    );

    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          chart,
          const SizedBox(height: defaultPadding),
          table,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: table),
        const SizedBox(width: defaultPadding),
        Expanded(flex: 2, child: chart),
      ],
    );
  }
}
