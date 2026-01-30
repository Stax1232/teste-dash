import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

import 'components/header.dart';
import '../../ohs/ui/ohs_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: const Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            OhsDashboard(),
          ],
        ),
      ),
    );
  }
}
