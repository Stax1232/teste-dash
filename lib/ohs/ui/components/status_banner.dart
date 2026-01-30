import 'package:flutter/material.dart';

class OhsStatusBanner extends StatelessWidget {
  final bool isLoading;
  final bool apiOnline;
  final String? lastError;

  const OhsStatusBanner({
    super.key,
    required this.isLoading,
    required this.apiOnline,
    required this.lastError,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    if (isLoading) {
      widgets.add(const LinearProgressIndicator());
    }

    if (!apiOnline) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange.withOpacity(0.15),
            border: Border.all(color: Colors.orange.withOpacity(0.6)),
          ),
          child: const Text(
            'API indisponível: exibindo dados locais/demonstração. Alterações podem não estar sendo persistidas no backend.',
          ),
        ),
      );
    }

    if (lastError != null && lastError!.trim().isNotEmpty) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.red.withOpacity(0.12),
            border: Border.all(color: Colors.red.withOpacity(0.5)),
          ),
          child: Text(lastError!),
        ),
      );
    }

    if (widgets.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets);
  }
}
