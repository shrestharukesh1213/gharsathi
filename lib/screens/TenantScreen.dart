import 'package:flutter/material.dart';

class Tenantscreen extends StatefulWidget {
  const Tenantscreen({super.key});

  @override
  State<Tenantscreen> createState() => _TenantscreenState();
}

class _TenantscreenState extends State<Tenantscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tenant HomeScreen'),
      ),
    );
  }
}