import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:lulu/providers/printer_provider.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PrinterProvider>().startScan(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Settings'),
      ),
      body: Consumer<PrinterProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.startScan(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              ListTile(
                title: const Text('Selected Printer'),
                subtitle: Text(
                  provider.selectedPrinter?.name ?? 'No printer selected',
                ),
                trailing: provider.selectedPrinter != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => provider.selectPrinter(null),
                      )
                    : null,
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<PrinterBluetooth>>(
                  stream: provider.discoveredDevices,
                  builder: (context, snapshot) {
                    if (provider.isScanning) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No printers found'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => provider.startScan(),
                              child: const Text('Scan Again'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final printer = snapshot.data![index];
                        return ListTile(
                          title: Text(printer.name ?? 'Unknown'),
                          subtitle: Text(printer.address ?? ''),
                          trailing: provider.selectedPrinter?.address ==
                                  printer.address
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () => provider.selectPrinter(printer.device),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PrinterProvider>().startScan(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    context.read<PrinterProvider>().stopScan();
    super.dispose();
  }
} 