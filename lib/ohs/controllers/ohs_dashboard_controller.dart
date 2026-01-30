import 'package:flutter/foundation.dart';

import '../data/atestado_repository.dart';
import '../data/hybrid_atestado_repository.dart';
import '../models/atestado_record.dart';
import '../models/ohs_aggregates.dart';
import '../models/ohs_filters.dart';

class OhsDashboardController extends ChangeNotifier {
  final AtestadoRepository repository;

  OhsDashboardController({required this.repository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _lastError;
  String? get lastError => _lastError;

  bool _apiOnline = true;
  bool get apiOnline => _apiOnline;

  List<AtestadoRecord> _all = [];
  List<AtestadoRecord> get allRecords => List.unmodifiable(_all);

  List<AtestadoRecord> _filtered = [];
  List<AtestadoRecord> get filteredRecords => List.unmodifiable(_filtered);

  OhsFilters _filters = OhsFilters.empty;
  OhsFilters get filters => _filters;

  Future<void> initialize() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final data = await repository.fetchAll();
      _all = data;
      _syncApiOnlineFlag();
      _sanitizeCascade();
      _recomputeFiltered();
    } catch (e) {
      _lastError = 'Falha ao carregar dados: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _syncApiOnlineFlag() {
    if (repository is HybridAtestadoRepository) {
      _apiOnline = (repository as HybridAtestadoRepository).apiOnline;
    } else {
      _apiOnline = true;
    }
  }

  // =====================
  // Filtros: opções
  // =====================
  List<String> get unidadeOptions => _unique(_all.map((e) => e.unidade));

  List<String> get areaOptions {
    final base = _applyAllFilters(exclude: 'area');
    return _unique(base.map((e) => e.area));
  }

  List<String> get supervisorOptions {
    final base = _applyAllFilters(exclude: 'supervisor');
    return _unique(base.map((e) => e.supervisor));
  }

  List<String> get idFuncOptions {
    final base = _applyAllFilters(exclude: 'idFunc');
    return _unique(base.map((e) => e.idFunc));
  }

  List<String> get generoOptions => ['M', 'F', 'O'];

  List<String> get cidOptions {
    final base = _applyAllFilters(exclude: 'cid');
    return _unique(base.map((e) => e.cid));
  }

  List<int> get anoOptions {
    final base = _applyAllFilters(exclude: 'ano');
    return _uniqueInt(base.map((e) => e.dataSaida.year))..sort();
  }

  List<int> get mesOptions {
    // Mes depende do ano selecionado (se existir)
    final base = _applyAllFilters(exclude: 'mes');
    final months = base.map((e) => e.dataSaida.month).toSet().toList()..sort();
    return months;
  }

  Iterable<AtestadoRecord> _applyAllFilters({required String exclude}) {
    return _all.where((r) {
      if (exclude != 'unidade' && _filters.unidade != null && r.unidade != _filters.unidade) return false;
      if (exclude != 'area' && _filters.area != null && r.area != _filters.area) return false;
      if (exclude != 'supervisor' && _filters.supervisor != null && r.supervisor != _filters.supervisor) return false;
      if (exclude != 'idFunc' && _filters.idFunc != null && r.idFunc != _filters.idFunc) return false;

      if (exclude != 'genero' && _filters.genero != null && r.genero != _filters.genero) return false;
      if (exclude != 'cid' && _filters.cid != null && r.cid != _filters.cid) return false;

      if (exclude != 'ano' && _filters.ano != null && r.dataSaida.year != _filters.ano) return false;
      if (exclude != 'mes' && _filters.mes != null && r.dataSaida.month != _filters.mes) return false;

      return true;
    });
  }

  List<String> _unique(Iterable<String> items) {
    final s = items.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    s.sort((a, b) => a.compareTo(b));
    return s;
  }

  List<int> _uniqueInt(Iterable<int> items) => items.toSet().toList();

  // =====================
  // Filtros: setters (cascata)
  // =====================
  void setUnidade(String? v) {
    _filters = _filters.copyWith(unidade: v, clearArea: true, clearSupervisor: true, clearIdFunc: true);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setArea(String? v) {
    _filters = _filters.copyWith(area: v, clearSupervisor: true, clearIdFunc: true);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setSupervisor(String? v) {
    _filters = _filters.copyWith(supervisor: v, clearIdFunc: true);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setIdFunc(String? v) {
    _filters = _filters.copyWith(idFunc: v);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setGenero(String? v) {
    _filters = _filters.copyWith(genero: v);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setCid(String? v) {
    _filters = _filters.copyWith(cid: v);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setAno(int? v) {
    _filters = _filters.copyWith(ano: v, clearMes: true);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void setMes(int? v) {
    _filters = _filters.copyWith(mes: v);
    _sanitizeCascade();
    _recomputeFiltered();
    notifyListeners();
  }

  void clearAllFilters() {
    _filters = OhsFilters.empty;
    _recomputeFiltered();
    notifyListeners();
  }

  void _sanitizeCascade() {
    // Garante que filtros escolhidos existam nas opções (evita estado inválido).
    // Cascata principal: Unidade -> Área -> Supervisor -> ID Func

    if (_filters.area != null && !areaOptions.contains(_filters.area)) {
      _filters = _filters.copyWith(clearArea: true, clearSupervisor: true, clearIdFunc: true);
    }
    if (_filters.supervisor != null && !supervisorOptions.contains(_filters.supervisor)) {
      _filters = _filters.copyWith(clearSupervisor: true, clearIdFunc: true);
    }
    if (_filters.idFunc != null && !idFuncOptions.contains(_filters.idFunc)) {
      _filters = _filters.copyWith(clearIdFunc: true);
    }

    if (_filters.cid != null && !cidOptions.contains(_filters.cid)) {
      _filters = _filters.copyWith(clearCid: true);
    }

    if (_filters.ano != null && !anoOptions.contains(_filters.ano)) {
      _filters = _filters.copyWith(clearAno: true, clearMes: true);
    }

    if (_filters.mes != null && !mesOptions.contains(_filters.mes)) {
      _filters = _filters.copyWith(clearMes: true);
    }
  }

  void _recomputeFiltered() {
    _filtered = _all.where((r) {
      if (_filters.unidade != null && r.unidade != _filters.unidade) return false;
      if (_filters.area != null && r.area != _filters.area) return false;
      if (_filters.supervisor != null && r.supervisor != _filters.supervisor) return false;
      if (_filters.idFunc != null && r.idFunc != _filters.idFunc) return false;

      if (_filters.genero != null && r.genero != _filters.genero) return false;
      if (_filters.cid != null && r.cid != _filters.cid) return false;

      if (_filters.ano != null && r.dataSaida.year != _filters.ano) return false;
      if (_filters.mes != null && r.dataSaida.month != _filters.mes) return false;

      return true;
    }).toList();
  }

  // =====================
  // CRUD
  // =====================
  Future<void> addAtestado(AtestadoRecord record) async {
    _lastError = null;
    notifyListeners();
    try {
      final created = await repository.create(record);
      _syncApiOnlineFlag();

      _all = [..._all, created];
      _sanitizeCascade();
      _recomputeFiltered();
      notifyListeners();
    } catch (e) {
      _lastError = 'Falha ao criar atestado: $e';
      notifyListeners();
    }
  }

  Future<void> updateAtestado(AtestadoRecord record) async {
    _lastError = null;
    notifyListeners();
    try {
      final updated = await repository.update(record);
      _syncApiOnlineFlag();

      final idx = _all.indexWhere((e) => e.id == updated.id);
      if (idx >= 0) {
        final next = [..._all];
        next[idx] = updated;
        _all = next;
      } else {
        _all = [..._all, updated];
      }

      _sanitizeCascade();
      _recomputeFiltered();
      notifyListeners();
    } catch (e) {
      _lastError = 'Falha ao atualizar atestado: $e';
      notifyListeners();
    }
  }

  Future<void> deleteAtestado(String id) async {
    _lastError = null;
    notifyListeners();
    try {
      await repository.delete(id);
      _syncApiOnlineFlag();

      _all = _all.where((e) => e.id != id).toList();
      _sanitizeCascade();
      _recomputeFiltered();
      notifyListeners();
    } catch (e) {
      _lastError = 'Falha ao excluir atestado: $e';
      notifyListeners();
    }
  }

  // =====================
  // KPIs
  // =====================
  int get totalAtestados => _filtered.length;

  int get totalDias => _filtered.fold<int>(0, (sum, r) => sum + r.diasAtestado);

  double get mediaDias => totalAtestados == 0 ? 0 : totalDias / totalAtestados;

  // =====================
  // Agregações (telas)
  // =====================
  Map<String, int> get atestadosPorUnidade {
    final m = <String, int>{};
    for (final r in _filtered) {
      m[r.unidade] = (m[r.unidade] ?? 0) + 1;
    }
    return m;
  }

  Map<String, int> get atestadosPorDiaSemana {
    String wd(int weekday) {
      switch (weekday) {
        case DateTime.monday:
          return 'Seg';
        case DateTime.tuesday:
          return 'Ter';
        case DateTime.wednesday:
          return 'Qua';
        case DateTime.thursday:
          return 'Qui';
        case DateTime.friday:
          return 'Sex';
        case DateTime.saturday:
          return 'Sáb';
        case DateTime.sunday:
          return 'Dom';
        default:
          return '-';
      }
    }

    final m = <String, int>{};
    for (final r in _filtered) {
      final k = wd(r.dataSaida.weekday);
      m[k] = (m[k] ?? 0) + 1;
    }

    // garante ordem
    final ordered = <String, int>{
      'Seg': m['Seg'] ?? 0,
      'Ter': m['Ter'] ?? 0,
      'Qua': m['Qua'] ?? 0,
      'Qui': m['Qui'] ?? 0,
      'Sex': m['Sex'] ?? 0,
      'Sáb': m['Sáb'] ?? 0,
      'Dom': m['Dom'] ?? 0,
    };
    return ordered;
  }

  int get chartYear {
    if (_filters.ano != null) return _filters.ano!;
    final years = _filtered.map((e) => e.dataSaida.year).toSet().toList()..sort();
    return years.isNotEmpty ? years.last : DateTime.now().year;
  }

  Map<int, int> atestadosPorMes(int year) {
    final m = <int, int>{for (var i = 1; i <= 12; i++) i: 0};
    for (final r in _filtered) {
      if (r.dataSaida.year == year) {
        m[r.dataSaida.month] = (m[r.dataSaida.month] ?? 0) + 1;
      }
    }
    return m;
  }

  Map<int, int> diasPorMes(int year) {
    final m = <int, int>{for (var i = 1; i <= 12; i++) i: 0};
    for (final r in _filtered) {
      if (r.dataSaida.year == year) {
        m[r.dataSaida.month] = (m[r.dataSaida.month] ?? 0) + r.diasAtestado;
      }
    }
    return m;
  }

  List<AreaAggregate> get areaAggregates {
    final byArea = <String, List<AtestadoRecord>>{};
    for (final r in _filtered) {
      byArea.putIfAbsent(r.area, () => []).add(r);
    }

    final list = <AreaAggregate>[];
    byArea.forEach((area, rows) {
      final at = rows.length;
      final dias = rows.fold<int>(0, (s, r) => s + r.diasAtestado);
      final ativos = rows.map((e) => e.idFunc).toSet().length;
      final media = at == 0 ? 0.0 : dias / at;
      list.add(
        AreaAggregate(
          area: area,
          atestados: at,
          dias: dias,
          ativos: ativos,
          mediaDias: media,
        ),
      );
    });

    list.sort((a, b) => b.dias.compareTo(a.dias));
    return list;
  }

  List<CidAggregate> get cidAggregates {
    final byCid = <String, List<AtestadoRecord>>{};
    for (final r in _filtered) {
      byCid.putIfAbsent(r.cid, () => []).add(r);
    }

    final list = <CidAggregate>[];
    byCid.forEach((cid, rows) {
      final at = rows.length;
      final dias = rows.fold<int>(0, (s, r) => s + r.diasAtestado);
      final media = at == 0 ? 0.0 : dias / at;
      // tema pode variar, pega o mais comum (simples)
      final tema = rows.first.cidTema;

      list.add(
        CidAggregate(
          cid: cid,
          cidTema: tema,
          atestados: at,
          dias: dias,
          mediaDias: media,
        ),
      );
    });

    list.sort((a, b) => b.dias.compareTo(a.dias));
    return list;
  }

  List<MedicoAggregate> get medicoAggregates {
    final byKey = <String, List<AtestadoRecord>>{};
    for (final r in _filtered) {
      final nome = (r.medicoNome ?? '').trim();
      final crm = (r.medicoCrm ?? '').trim();
      final key = '${nome.isEmpty ? '—' : nome}||$crm';
      byKey.putIfAbsent(key, () => []).add(r);
    }

    final list = <MedicoAggregate>[];
    byKey.forEach((key, rows) {
      final parts = key.split('||');
      final nome = parts.first.trim().isEmpty ? '—' : parts.first.trim();
      final crm = parts.length > 1 && parts[1].trim().isNotEmpty ? parts[1].trim() : null;

      final at = rows.length;
      final dias = rows.fold<int>(0, (s, r) => s + r.diasAtestado);
      final media = at == 0 ? 0.0 : dias / at;

      list.add(MedicoAggregate(
        medicoNome: nome,
        crm: crm,
        atestados: at,
        dias: dias,
        mediaDias: media,
      ));
    });

    list.sort((a, b) => b.atestados.compareTo(a.atestados));
    return list;
  }

  Map<String, int> get atestadosPorCidCategoria {
    final m = <String, int>{};
    for (final r in _filtered) {
      final k = r.cidCategoria;
      m[k] = (m[k] ?? 0) + 1;
    }
    final keys = m.keys.toList()..sort();
    return {for (final k in keys) k: m[k] ?? 0};
  }
}
