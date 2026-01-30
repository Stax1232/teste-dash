import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/atestado_record.dart';
import 'atestado_repository.dart';

class ApiAtestadoRepository implements AtestadoRepository {
  final http.Client _client;

  ApiAtestadoRepository({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers() {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = kApiBearerToken.trim();
    if (token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }

    return h;
  }

  List<dynamic> _asList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map && decoded['data'] is List) return decoded['data'] as List;
    return const [];
  }

  @override
  Future<List<AtestadoRecord>> fetchAll() async {
    final uri = apiUri(kAtestadosEndpoint);
    final resp = await _client.get(uri, headers: _headers()).timeout(kApiTimeout);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API GET falhou (${resp.statusCode})');
    }

    final body = utf8.decode(resp.bodyBytes);
    final decoded = json.decode(body);
    final list = _asList(decoded);

    return list
        .whereType<Map>()
        .map((m) => AtestadoRecord.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<AtestadoRecord> create(AtestadoRecord record) async {
    final uri = apiUri(kAtestadosEndpoint);
    final resp = await _client
        .post(uri, headers: _headers(), body: json.encode(record.toJson()))
        .timeout(kApiTimeout);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API POST falhou (${resp.statusCode})');
    }

    // Aceita: retorna o objeto criado ou retorna lista/estrutura. Se não vier, devolve o record.
    final body = utf8.decode(resp.bodyBytes);
    if (body.trim().isEmpty) return record;

    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      return AtestadoRecord.fromJson(decoded);
    }

    return record;
  }

  @override
  Future<AtestadoRecord> update(AtestadoRecord record) async {
    final uri = apiUri('${kAtestadosEndpoint}/${record.id}');
    final resp = await _client
        .put(uri, headers: _headers(), body: json.encode(record.toJson()))
        .timeout(kApiTimeout);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API PUT falhou (${resp.statusCode})');
    }

    final body = utf8.decode(resp.bodyBytes);
    if (body.trim().isEmpty) return record;

    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      return AtestadoRecord.fromJson(decoded);
    }

    return record;
  }

  @override
  Future<void> delete(String id) async {
    final uri = apiUri('${kAtestadosEndpoint}/$id');
    final resp = await _client.delete(uri, headers: _headers()).timeout(kApiTimeout);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('API DELETE falhou (${resp.statusCode})');
    }
  }
}
