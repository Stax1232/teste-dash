import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/ohs_dashboard_controller.dart';
import '../../models/atestado_record.dart';
import '../widgets/atestado_form_dialog.dart';

class OhsFilterBar extends StatelessWidget {
  const OhsFilterBar({super.key});

  static const _monthNames = <int, String>{
    1: 'Jan', 2: 'Fev', 3: 'Mar', 4: 'Abr', 5: 'Mai', 6: 'Jun',
    7: 'Jul', 8: 'Ago', 9: 'Set', 10: 'Out', 11: 'Nov', 12: 'Dez',
  };

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OhsDashboardController>();

    Widget dropString({
      required String label,
      required String? value,
      required List<String> options,
      required void Function(String? v) onChanged,
    }) {
      return SizedBox(
        width: 190,
        child: DropdownButtonFormField<String?>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: secondaryColor,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          items: <DropdownMenuItem<String?>>[
            const DropdownMenuItem(value: null, child: Text('Todos')),
            ...options.map((o) => DropdownMenuItem(value: o, child: Text(o))),
          ],
          onChanged: onChanged,
        ),
      );
    }

    Widget dropInt({
      required String label,
      required int? value,
      required List<int> options,
      required void Function(int? v) onChanged,
      String Function(int v)? labelOf,
    }) {
      return SizedBox(
        width: 150,
        child: DropdownButtonFormField<int?>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: secondaryColor,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          items: <DropdownMenuItem<int?>>[
            const DropdownMenuItem(value: null, child: Text('Todos')),
            ...options.map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(labelOf != null ? labelOf(o) : o.toString()),
                )),
          ],
          onChanged: onChanged,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: defaultPadding,
            runSpacing: defaultPadding,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              dropString(
                label: 'Unidade',
                value: ctrl.filters.unidade,
                options: ctrl.unidadeOptions,
                onChanged: ctrl.setUnidade,
              ),
              dropString(
                label: 'Área',
                value: ctrl.filters.area,
                options: ctrl.areaOptions,
                onChanged: ctrl.setArea,
              ),
              dropString(
                label: 'Supervisor',
                value: ctrl.filters.supervisor,
                options: ctrl.supervisorOptions,
                onChanged: ctrl.setSupervisor,
              ),
              dropString(
                label: 'ID Func',
                value: ctrl.filters.idFunc,
                options: ctrl.idFuncOptions,
                onChanged: ctrl.setIdFunc,
              ),
              dropString(
                label: 'Gênero',
                value: ctrl.filters.genero,
                options: ctrl.generoOptions,
                onChanged: ctrl.setGenero,
              ),
              dropString(
                label: 'CID',
                value: ctrl.filters.cid,
                options: ctrl.cidOptions,
                onChanged: ctrl.setCid,
              ),
              dropInt(
                label: 'Ano',
                value: ctrl.filters.ano,
                options: ctrl.anoOptions,
                onChanged: ctrl.setAno,
              ),
              dropInt(
                label: 'Mês',
                value: ctrl.filters.mes,
                options: ctrl.mesOptions,
                onChanged: ctrl.setMes,
                labelOf: (m) => '${m.toString().padLeft(2, '0')} • ${_monthNames[m] ?? ''}',
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          Wrap(
            spacing: defaultPadding,
            runSpacing: defaultPadding,
            children: [
              OutlinedButton.icon(
                onPressed: ctrl.clearAllFilters,
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Limpar filtros'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final id = DateTime.now().microsecondsSinceEpoch.toString();

                  final newRecord = AtestadoRecord(
                    id: id,
                    unidade: '',
                    idFunc: '',
                    genero: 'M',
                    area: '',
                    supervisor: '',
                    cid: '',
                    cidTema: '',
                    medicoNome: null,
                    medicoCrm: null,
                    dataSaida: DateTime(now.year, now.month, now.day),
                    dataRetorno: DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
                  );

                  await showAtestadoFormDialog(
                    context: context,
                    title: 'Novo Atestado',
                    initial: newRecord,
                    onSubmit: (r) => context.read<OhsDashboardController>().addAtestado(r),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Novo atestado'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
