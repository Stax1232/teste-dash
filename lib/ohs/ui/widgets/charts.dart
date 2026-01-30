import 'package:admin/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OhsLineTwoSeriesChart extends StatelessWidget {
  final Map<int, int> seriesA; // month -> value
  final Map<int, int> seriesB;
  final String labelA;
  final String labelB;

  const OhsLineTwoSeriesChart({
    super.key,
    required this.seriesA,
    required this.seriesB,
    required this.labelA,
    required this.labelB,
  });

  List<FlSpot> _spots(Map<int, int> m) {
    return List.generate(12, (i) {
      final month = i + 1;
      final v = (m[month] ?? 0).toDouble();
      return FlSpot(month.toDouble(), v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final aSpots = _spots(seriesA);
    final bSpots = _spots(seriesB);

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final m = value.toInt();
                      const labels = ['','Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];
                      if (m < 1 || m > 12) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(labels[m], style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 36),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: aSpots,
                  isCurved: true,
                  color: primaryColor,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: bSpots,
                  isCurved: true,
                  color: primaryColor.withOpacity(0.45),
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 14,
          children: [
            _LegendDot(labelA, primaryColor),
            _LegendDot(labelB, primaryColor.withOpacity(0.45)),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendDot(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class OhsBarChartSingle extends StatelessWidget {
  final List<String> labels;
  final List<int> values;

  const OhsBarChartSingle({
    super.key,
    required this.labels,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final groups = <BarChartGroupData>[];
    for (var i = 0; i < labels.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: values[i].toDouble(),
              color: primaryColor,
              width: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(labels[idx], style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          barGroups: groups,
        ),
      ),
    );
  }
}

class OhsDonutTopChart extends StatelessWidget {
  final List<String> labels;
  final List<int> values;

  const OhsDonutTopChart({
    super.key,
    required this.labels,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final total = values.fold<int>(0, (s, v) => s + v);
    if (total == 0) {
      return const SizedBox(height: 220, child: Center(child: Text('Sem dados')));
    }

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < labels.length; i++) {
      final v = values[i].toDouble();
      final opacity = 0.25 + (i * 0.12);
      sections.add(
        PieChartSectionData(
          value: v,
          color: primaryColor.withOpacity(opacity.clamp(0.25, 0.95)),
          radius: 55,
          title: '',
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 42,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < labels.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity((0.25 + (i * 0.12)).clamp(0.25, 0.95)),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(labels[i])),
                Text(values[i].toString()),
              ],
            ),
          ),
      ],
    );
  }
}
