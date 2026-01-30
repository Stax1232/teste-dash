import '../models/atestado_record.dart';
import 'api_atestado_repository.dart';
import 'atestado_repository.dart';
import 'in_memory_atestado_repository.dart';

class HybridAtestadoRepository implements AtestadoRepository {
  final ApiAtestadoRepository api;
  final InMemoryAtestadoRepository local;

  bool _apiOnline = true;
  bool get apiOnline => _apiOnline;

  HybridAtestadoRepository({required this.api, required this.local});

  @override
  Future<List<AtestadoRecord>> fetchAll() async {
    try {
      final data = await api.fetchAll();
      _apiOnline = true;
      local.replaceAll(data);
      return data;
    } catch (_) {
      _apiOnline = false;
      return local.fetchAll();
    }
  }

  @override
  Future<AtestadoRecord> create(AtestadoRecord record) async {
    if (_apiOnline) {
      try {
        final created = await api.create(record);
        local.create(created);
        return created;
      } catch (_) {
        _apiOnline = false;
        return local.create(record);
      }
    }
    return local.create(record);
  }

  @override
  Future<AtestadoRecord> update(AtestadoRecord record) async {
    if (_apiOnline) {
      try {
        final updated = await api.update(record);
        local.update(updated);
        return updated;
      } catch (_) {
        _apiOnline = false;
        return local.update(record);
      }
    }
    return local.update(record);
  }

  @override
  Future<void> delete(String id) async {
    if (_apiOnline) {
      try {
        await api.delete(id);
        await local.delete(id);
        return;
      } catch (_) {
        _apiOnline = false;
        await local.delete(id);
        return;
      }
    }
    await local.delete(id);
  }
}
