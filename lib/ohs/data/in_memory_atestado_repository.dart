import 'dart:math';

import '../models/atestado_record.dart';
import 'atestado_repository.dart';

class InMemoryAtestadoRepository implements AtestadoRepository {
  final List<AtestadoRecord> _items;

  InMemoryAtestadoRepository._(this._items);

  factory InMemoryAtestadoRepository.seeded() {
    final rnd = Random(42);

    final unidades = ['Matriz', 'Filial 1', 'Filial 2'];
    final areas = ['Produção', 'Manutenção', 'Logística', 'Administrativo'];
    final supervisores = ['Ana', 'Bruno', 'Carla', 'Diego'];
    final cids = [
      ('M54.5', 'Dor lombar baixa'),
      ('F41.1', 'Ansiedade generalizada'),
      ('J06.9', 'Infecção vias aéreas superiores'),
      ('S93.4', 'Entorse de tornozelo'),
      ('Z00.0', 'Exame geral'),
    ];

    final baseDates = <DateTime>[
      DateTime(2024, 1, 10),
      DateTime(2024, 3, 5),
      DateTime(2024, 6, 18),
      DateTime(2024, 9, 2),
      DateTime(2025, 1, 15),
      DateTime(2025, 4, 22),
      DateTime(2025, 7, 9),
      DateTime(2025, 10, 28),
    ];

    final list = <AtestadoRecord>[];

    for (var i = 0; i < 70; i++) {
      final saidaBase = baseDates[rnd.nextInt(baseDates.length)];
      final saida = saidaBase.add(Duration(days: rnd.nextInt(25)));
      final dias = 1 + rnd.nextInt(12);
      final retorno = saida.add(Duration(days: dias));

      final cidItem = cids[rnd.nextInt(cids.length)];

      final medicoVazio = rnd.nextBool();

      list.add(
        AtestadoRecord(
          id: 'seed_${i}_${saida.microsecondsSinceEpoch}',
          unidade: unidades[rnd.nextInt(unidades.length)],
          idFunc: (1000 + rnd.nextInt(120)).toString(),
          genero: ['M', 'F', 'O'][rnd.nextInt(3)],
          area: areas[rnd.nextInt(areas.length)],
          supervisor: supervisores[rnd.nextInt(supervisores.length)],
          cid: cidItem.$1,
          cidTema: cidItem.$2,
          medicoNome: medicoVazio ? null : ['Dr. Paulo', 'Dra. Luana', 'Dr. Rafael'][rnd.nextInt(3)],
          medicoCrm: medicoVazio ? null : ['CRM123', 'CRM456', 'CRM789'][rnd.nextInt(3)],
          dataSaida: DateTime(saida.year, saida.month, saida.day),
          dataRetorno: DateTime(retorno.year, retorno.month, retorno.day),
        ),
      );
    }

    return InMemoryAtestadoRepository._(list);
  }

  @override
  Future<List<AtestadoRecord>> fetchAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<AtestadoRecord> create(AtestadoRecord record) async {
    _items.add(record);
    return record;
  }

  @override
  Future<AtestadoRecord> update(AtestadoRecord record) async {
    final idx = _items.indexWhere((e) => e.id == record.id);
    if (idx >= 0) {
      _items[idx] = record;
      return record;
    }
    _items.add(record);
    return record;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
  }

  void replaceAll(List<AtestadoRecord> items) {
    _items
      ..clear()
      ..addAll(items);
  }
}
