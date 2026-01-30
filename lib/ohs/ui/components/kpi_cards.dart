import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/ohs_dashboard_controller.dart';

class OhsKpiCards extends StatelessWidget {
  const OhsKpiCards({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OhsDashboardController>();

    Widget card(String title, String value) {
      return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final cards = <Widget>[
      card('Atestados Médicos', ctrl.totalAtestados.toString()),
      card('Dias de Atestado', ctrl.totalDias.toString()),
      card('Média de Dias', ctrl.mediaDias.toStringAsFixed(2)),
    ];

    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          for (final c in cards) ...[
            c,
            const SizedBox(height: defaultPadding),
          ],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: defaultPadding),
        Expanded(child: cards[1]),
        const SizedBox(width: defaultPadding),
        Expanded(child: cards[2]),
      ],
    );
  }
}
