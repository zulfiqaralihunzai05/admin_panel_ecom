import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer-widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
        iconTheme: Theme.of(context).primaryIconTheme,
        title: const Text('Admin Panel', style: TextStyle(color: Colors.white),),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
