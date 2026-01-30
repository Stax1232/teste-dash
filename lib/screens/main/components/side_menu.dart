import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuAppController>();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/LOGO FIXER RBANCA .png"),
          ),

          DrawerListTile(
            title: "Visão Geral",
            svgSrc: "assets/icons/menu_dashboard.svg",
            isSelected: menu.selectedSection == OhsSection.visaoGeral,
            press: () {
              context.read<MenuAppController>().setSection(OhsSection.visaoGeral);
              if (!Responsive.isDesktop(context)) Navigator.of(context).pop();
            },
          ),
          DrawerListTile(
            title: "Distribuição",
            svgSrc: "assets/icons/menu_tran.svg",
            isSelected: menu.selectedSection == OhsSection.distribuicao,
            press: () {
              context.read<MenuAppController>().setSection(OhsSection.distribuicao);
              if (!Responsive.isDesktop(context)) Navigator.of(context).pop();
            },
          ),
          DrawerListTile(
            title: "CID",
            svgSrc: "assets/icons/menu_doc.svg",
            isSelected: menu.selectedSection == OhsSection.cid,
            press: () {
              context.read<MenuAppController>().setSection(OhsSection.cid);
              if (!Responsive.isDesktop(context)) Navigator.of(context).pop();
            },
          ),
          DrawerListTile(
            title: "Médicos",
            svgSrc: "assets/icons/menu_profile.svg",
            isSelected: menu.selectedSection == OhsSection.medicos,
            press: () {
              context.read<MenuAppController>().setSection(OhsSection.medicos);
              if (!Responsive.isDesktop(context)) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isSelected,
  });

  final String title, svgSrc;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : Colors.white54;

    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(title, style: TextStyle(color: color)),
      selected: isSelected,
    );
  }
}
