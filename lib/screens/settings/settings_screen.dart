import 'package:flutter/material.dart';
import 'package:lulu/screens/settings/printer_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.bluetooth),
            title: const Text('Printer Settings'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrinterSettingsScreen(),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.business),
            title: Text('Business Information'),
            // TODO: Implement business info settings
          ),
        ],
      ),
    );
  }
} 