import 'package:admin/constants.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/ohs_dashboard_controller.dart';
import 'components/filter_bar.dart';
import 'components/kpi_cards.dart';
import 'components/status_banner.dart';
import 'pages/cid_page.dart';
import 'pages/distribuicao_page.dart';
import 'pages/medicos_page.dart';
import 'pages/visao_geral_page.dart';

class OhsDashboard extends StatelessWidget {
  const OhsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuAppController>();
    final ctrl = context.watch<OhsDashboardController>();

    Widget page;
    switch (menu.selectedSection) {
      case OhsSection.visaoGeral:
        page = const VisaoGeralPage();
        break;
      case OhsSection.distribuicao:
        page = const DistribuicaoPage();
        break;
      case OhsSection.cid:
        page = const CidPage();
        break;
      case OhsSection.medicos:
        page = const MedicosPage();
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saúde do Trabalho • ${menu.selectedSection.title}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: defaultPadding / 2),

        OhsStatusBanner(
          isLoading: ctrl.isLoading,
          apiOnline: ctrl.apiOnline,
          lastError: ctrl.lastError,
        ),
        const SizedBox(height: defaultPadding),

        const OhsFilterBar(),
        const SizedBox(height: defaultPadding),

        const OhsKpiCards(),
        const SizedBox(height: defaultPadding),

        page,
      ],
    );
  }
}
