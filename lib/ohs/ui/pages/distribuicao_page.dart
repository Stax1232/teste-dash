import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/ohs_dashboard_controller.dart';
import '../widgets/charts.dart';
import '../widgets/ohs_card.dart';
import '../widgets/tables.dart';

class DistribuicaoPage extends StatelessWidget {
  const DistribuicaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OhsDashboardController>();
    final areas = ctrl.areaAggregates;

    final topArea = areas.take(6).toList();
    final topLabels = topArea.map((e) => e.area).toList();
    final topDias = topArea.map((e) => e.dias).toList();

    final donutTop5 = areas.take(5).toList();
    final donutLabels = donutTop5.map((e) => e.area).toList();
    final donutValues = donutTop5.map((e) => e.dias).toList();

    final chartByMonth = OhsCard(
      title: 'Atestados e Dias por Mês',
      child: Builder(
        builder: (_) {
          final y = ctrl.chartYear;
          final at = ctrl.atestadosPorMes(y);
          final dias = ctrl.diasPorMes(y);

          final labels = List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
          final values = List.generate(12, (i) => (at[i + 1] ?? 0));

          // simples: barra de atestados (se quiser 2 séries depois, a gente evolui)
          return OhsBarChartSingle(labels: labels, values: values);
        },
      ),
    );

    final leftTop = OhsCard(
      title: 'Dias de Atestado por Área (Top)',
      child: topLabels.isEmpty
          ? const SizedBox(height: 220, child: Center(child: Text('Sem dados')))
          : OhsBarChartSingle(labels: topLabels, values: topDias),
    );

    final table = OhsCard(
      title: 'Tabela por Área',
      child: AreaSummaryTable(rows: areas),
    );

    final donut = OhsCard(
      title: 'Top 5 • Dias de Atestado',
      child: OhsDonutTopChart(labels: donutLabels, values: donutValues),
    );

    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          leftTop,
          const SizedBox(height: defaultPadding),
          chartByMonth,
          const SizedBox(height: defaultPadding),
          table,
          const SizedBox(height: defaultPadding),
          donut,
        ],
      );
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: leftTop),
            const SizedBox(width: defaultPadding),
            Expanded(flex: 2, child: donut),
          ],
        ),
        const SizedBox(height: defaultPadding),
        chartByMonth,
        const SizedBox(height: defaultPadding),
        table,
      ],
    );
  }
}
