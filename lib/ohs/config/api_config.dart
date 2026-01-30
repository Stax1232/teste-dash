/// Configuração de API via `--dart-define`.
///
/// Exemplos:
/// flutter run -d chrome --dart-define=API_BASE_URL=https://minha-api.com --dart-define=API_TOKEN=xxxxx
///
/// Se API_BASE_URL ficar vazio, no Flutter Web a app tenta usar URL relativa (mesma origem):
/// GET /api/atestados
const String kApiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
const String kApiBearerToken = String.fromEnvironment('API_TOKEN', defaultValue: '');

const Duration kApiTimeout = Duration(seconds: 15);

const String kAtestadosEndpoint = '/api/atestados';

Uri apiUri(String path) {
  final trimmed = kApiBaseUrl.trim();
  if (trimmed.isEmpty) {
    // URL relativa (bom para Flutter Web com reverse proxy).
    return Uri(path: path);
  }

  final base = Uri.parse(trimmed);

  final basePath = base.path.endsWith('/')
      ? base.path.substring(0, base.path.length - 1)
      : base.path;

  final nextPath = path.startsWith('/') ? path : '/$path';

  return base.replace(path: '$basePath$nextPath');
}
