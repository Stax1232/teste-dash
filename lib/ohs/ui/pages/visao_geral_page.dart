import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/ohs_dashboard_controller.dart';
import '../widgets/atestado_form_dialog.dart';
import '../widgets/charts.dart';
import '../widgets/ohs_card.dart';
import '../widgets/tables.dart';

class VisaoGeralPage extends StatelessWidget {
  const VisaoGeralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OhsDashboardController>();

    final year = ctrl.chartYear;
    final prev = year - 1;

    final line = OhsCard(
      title: 'Atestados por Mês',
      child: OhsLineTwoSeriesChart(
        seriesA: ctrl.atestadosPorMes(prev),
        seriesB: ctrl.atestadosPorMes(year),
        labelA: prev.toString(),
        labelB: year.toString(),
      ),
    );

    final table = OhsCard(
      title: 'Registros (últimos 12)',
      child: AtestadoTable(
        rows: ctrl.filteredRecords,
        onEdit: (r) async {
          await showAtestadoFormDialog(
            context: context,
            title: 'Editar Atestado',
            initial: r,
            onSubmit: (x) => context.read<OhsDashboardController>().updateAtestado(x),
          );
        },
        onDelete: (r) async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Excluir atestado?'),
              content: Text('ID Func: ${r.idFunc}\nCID: ${r.cid}\nSaída: ${formatBrDate(r.dataSaida)}'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
              ],
            ),
          );
          if (ok == true) {
            await context.read<OhsDashboardController>().deleteAtestado(r.id);
          }
        },
      ),
    );

    final right1 = OhsCard(
      title: 'Atestados por Unidade',
      child: Builder(
        builder: (_) {
          final m = ctrl.atestadosPorUnidade;
          final labels = m.keys.toList();
          final values = labels.map((k) => m[k] ?? 0).toList();
          if (labels.isEmpty) return const SizedBox(height: 220, child: Center(child: Text('Sem dados')));
          return OhsBarChartSingle(labels: labels, values: values);
        },
      ),
    );

    final right2 = OhsCard(
      title: 'Atestados por Dia da Semana',
      child: Builder(
        builder: (_) {
          final m = ctrl.atestadosPorDiaSemana;
          final labels = m.keys.toList();
          final values = labels.map((k) => m[k] ?? 0).toList();
          return OhsBarChartSingle(labels: labels, values: values);
        },
      ),
    );

    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          line,
          const SizedBox(height: defaultPadding),
          table,
          const SizedBox(height: defaultPadding),
          right1,
          const SizedBox(height: defaultPadding),
          right2,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              line,
              const SizedBox(height: defaultPadding),
              table,
            ],
          ),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              right1,
              const SizedBox(height: defaultPadding),
              right2,
            ],
          ),
        ),
      ],
    );
  }
}
