import 'package:flutter/material.dart';

import '../../models/atestado_record.dart';
import '../../models/ohs_aggregates.dart';

String formatBrDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year.toString().padLeft(4, '0')}';

class AtestadoTable extends StatelessWidget {
  final List<AtestadoRecord> rows;
  final void Function(AtestadoRecord r) onEdit;
  final void Function(AtestadoRecord r) onDelete;

  const AtestadoTable({
    super.key,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ordered = [...rows]..sort((a, b) => b.dataSaida.compareTo(a.dataSaida));
    final limited = ordered.take(12).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID Func')),
          DataColumn(label: Text('Data Saída')),
          DataColumn(label: Text('Data Retorno')),
          DataColumn(label: Text('Dias')),
          DataColumn(label: Text('CID')),
          DataColumn(label: Text('Ações')),
        ],
        rows: limited.map((r) {
          return DataRow(
            cells: [
              DataCell(Text(r.idFunc)),
              DataCell(Text(formatBrDate(r.dataSaida))),
              DataCell(Text(formatBrDate(r.dataRetorno))),
              DataCell(Text(r.diasAtestado.toString())),
              DataCell(Text(r.cid)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Editar',
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => onEdit(r),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete_outline, size: 18),
                      onPressed: () => onDelete(r),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class AreaSummaryTable extends StatelessWidget {
  final List<AreaAggregate> rows;
  const AreaSummaryTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final limited = rows.take(12).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Área')),
          DataColumn(label: Text('Atestados')),
          DataColumn(label: Text('Dias')),
          DataColumn(label: Text('Ativos')),
        ],
        rows: limited.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.area)),
            DataCell(Text(r.atestados.toString())),
            DataCell(Text(r.dias.toString())),
            DataCell(Text(r.ativos.toString())),
          ]);
        }).toList(),
      ),
    );
  }
}

class CidSummaryTable extends StatelessWidget {
  final List<CidAggregate> rows;
  const CidSummaryTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final limited = rows.take(15).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('CID')),
          DataColumn(label: Text('Tema')),
          DataColumn(label: Text('Atestados')),
          DataColumn(label: Text('Média Dias')),
          DataColumn(label: Text('Dias')),
        ],
        rows: limited.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.cid)),
            DataCell(Text(r.cidTema)),
            DataCell(Text(r.atestados.toString())),
            DataCell(Text(r.mediaDias.toStringAsFixed(2))),
            DataCell(Text(r.dias.toString())),
          ]);
        }).toList(),
      ),
    );
  }
}

class MedicoSummaryTable extends StatelessWidget {
  final List<MedicoAggregate> rows;
  const MedicoSummaryTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final limited = rows.take(15).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('CRM')),
          DataColumn(label: Text('Médico')),
          DataColumn(label: Text('Atestados')),
          DataColumn(label: Text('Média Dias')),
          DataColumn(label: Text('Dias')),
        ],
        rows: limited.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.crm ?? '—')),
            DataCell(Text(r.medicoNome)),
            DataCell(Text(r.atestados.toString())),
            DataCell(Text(r.mediaDias.toStringAsFixed(2))),
            DataCell(Text(r.dias.toString())),
          ]);
        }).toList(),
      ),
    );
  }
}
