import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/ohs_dashboard_controller.dart';
import '../widgets/charts.dart';
import '../widgets/ohs_card.dart';
import '../widgets/tables.dart';

class CidPage extends StatelessWidget {
  const CidPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OhsDashboardController>();
    final rows = ctrl.cidAggregates;

    final table = OhsCard(
      title: 'CID • Resumo',
      child: CidSummaryTable(rows: rows),
    );

    final chart = OhsCard(
      title: 'Atestados por Categoria (1ª letra do CID)',
      child: Builder(
        builder: (_) {
          final m = ctrl.atestadosPorCidCategoria;
          final labels = m.keys.toList();
          final values = labels.map((k) => m[k] ?? 0).toList();
          if (labels.isEmpty) return const SizedBox(height: 220, child: Center(child: Text('Sem dados')));
          return OhsBarChartSingle(labels: labels, values: values);
        },
      ),
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
