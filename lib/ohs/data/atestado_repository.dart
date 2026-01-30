import '../models/atestado_record.dart';

abstract class AtestadoRepository {
  Future<List<AtestadoRecord>> fetchAll();
  Future<AtestadoRecord> create(AtestadoRecord record);
  Future<AtestadoRecord> update(AtestadoRecord record);
  Future<void> delete(String id);
}
