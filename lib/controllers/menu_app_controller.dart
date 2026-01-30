import 'package:flutter/material.dart';

enum OhsSection { visaoGeral, distribuicao, cid, medicos }

extension OhsSectionX on OhsSection {
  String get title {
    switch (this) {
      case OhsSection.visaoGeral:
        return 'Visão Geral';
      case OhsSection.distribuicao:
        return 'Distribuição';
      case OhsSection.cid:
        return 'CID';
      case OhsSection.medicos:
        return 'Médicos';
    }
  }
}

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  OhsSection _selectedSection = OhsSection.visaoGeral;
  OhsSection get selectedSection => _selectedSection;

  void setSection(OhsSection section) {
    if (_selectedSection == section) return;
    _selectedSection = section;
    notifyListeners();
  }

  void controlMenu() {
    final state = _scaffoldKey.currentState;
    if (state == null) return;

    if (!state.isDrawerOpen) {
      state.openDrawer();
    }
  }
}
