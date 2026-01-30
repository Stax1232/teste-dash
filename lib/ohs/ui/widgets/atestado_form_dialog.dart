import 'package:flutter/material.dart';

import '../../models/atestado_record.dart';

Future<void> showAtestadoFormDialog({
  required BuildContext context,
  required String title,
  required AtestadoRecord initial,
  required Future<void> Function(AtestadoRecord) onSubmit,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AtestadoFormDialog(title: title, initial: initial, onSubmit: onSubmit),
  );
}

class _AtestadoFormDialog extends StatefulWidget {
  final String title;
  final AtestadoRecord initial;
  final Future<void> Function(AtestadoRecord) onSubmit;

  const _AtestadoFormDialog({
    required this.title,
    required this.initial,
    required this.onSubmit,
  });

  @override
  State<_AtestadoFormDialog> createState() => _AtestadoFormDialogState();
}

class _AtestadoFormDialogState extends State<_AtestadoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  late DateTime _saida;
  late DateTime _retorno;

  late final TextEditingController _unidade;
  late final TextEditingController _idFunc;
  String _genero = 'M';
  late final TextEditingController _area;
  late final TextEditingController _supervisor;
  late final TextEditingController _cid;
  late final TextEditingController _cidTema;
  late final TextEditingController _medicoNome;
  late final TextEditingController _medicoCrm;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;

    _saida = i.dataSaida;
    _retorno = i.dataRetorno;

    _unidade = TextEditingController(text: i.unidade);
    _idFunc = TextEditingController(text: i.idFunc);
    _genero = i.genero.isEmpty ? 'M' : i.genero;
    _area = TextEditingController(text: i.area);
    _supervisor = TextEditingController(text: i.supervisor);
    _cid = TextEditingController(text: i.cid);
    _cidTema = TextEditingController(text: i.cidTema);
    _medicoNome = TextEditingController(text: i.medicoNome ?? '');
    _medicoCrm = TextEditingController(text: i.medicoCrm ?? '');
  }

  @override
  void dispose() {
    _unidade.dispose();
    _idFunc.dispose();
    _area.dispose();
    _supervisor.dispose();
    _cid.dispose();
    _cidTema.dispose();
    _medicoNome.dispose();
    _medicoCrm.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year.toString().padLeft(4, '0')}';

  Future<void> _pickSaida() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _saida,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked == null) return;

    setState(() {
      _saida = DateTime(picked.year, picked.month, picked.day);
      if (_retorno.isBefore(_saida)) {
        _retorno = _saida.add(const Duration(days: 1));
      }
    });
  }

  Future<void> _pickRetorno() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _retorno,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked == null) return;

    final dt = DateTime(picked.year, picked.month, picked.day);
    if (dt.isBefore(_saida)) return;

    setState(() {
      _retorno = dt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dias = _retorno.difference(_saida).inDays;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 680,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _field(_unidade, 'Unidade', required: true),
                _field(_idFunc, 'ID Func', required: true),
                SizedBox(
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    value: _genero,
                    decoration: const InputDecoration(
                      labelText: 'Gênero',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('M')),
                      DropdownMenuItem(value: 'F', child: Text('F')),
                      DropdownMenuItem(value: 'O', child: Text('O')),
                    ],
                    onChanged: (v) => setState(() => _genero = v ?? 'M'),
                  ),
                ),
                _field(_area, 'Área', required: true),
                _field(_supervisor, 'Supervisor', required: true),
                _field(_cid, 'CID', required: true),
                _field(_cidTema, 'Tema/Descrição CID', required: true),
                _field(_medicoNome, 'Médico (opcional)', required: false),
                _field(_medicoCrm, 'CRM (opcional)', required: false),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickSaida,
                        icon: const Icon(Icons.event),
                        label: Text('Saída: ${_fmt(_saida)}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickRetorno,
                        icon: const Icon(Icons.event_available),
                        label: Text('Retorno: ${_fmt(_retorno)}'),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Dias calculados automaticamente: $dias'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saving
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;

                  final record = widget.initial.copyWith(
                    unidade: _unidade.text.trim(),
                    idFunc: _idFunc.text.trim(),
                    genero: _genero,
                    area: _area.text.trim(),
                    supervisor: _supervisor.text.trim(),
                    cid: _cid.text.trim(),
                    cidTema: _cidTema.text.trim(),
                    medicoNome: _medicoNome.text.trim().isEmpty ? null : _medicoNome.text.trim(),
                    medicoCrm: _medicoCrm.text.trim().isEmpty ? null : _medicoCrm.text.trim(),
                    dataSaida: _saida,
                    dataRetorno: _retorno,
                  );

                  setState(() => _saving = true);
                  try {
                    await widget.onSubmit(record);
                    if (mounted) Navigator.of(context).pop();
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
          child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Salvar'),
        ),
      ],
    );
  }

  Widget _field(TextEditingController c, String label, {required bool required}) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        validator: (v) {
          if (!required) return null;
          if (v == null || v.trim().isEmpty) return 'Obrigatório';
          return null;
        },
      ),
    );
  }
}
