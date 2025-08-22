import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import 'create_company_screen.dart';
import 'create_service_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});
  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppState>().refresh());
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Companies'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: st.refresh,
        child: Builder(
          builder: (_) {
            if (st.loading) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                itemBuilder: (_, __) => const _SkeletonCard(),
              );
            }
            if (st.error != null) {
              return _MessageState(
                icon: Icons.error_outline,
                title: 'Something went wrong',
                subtitle: st.error!,
                actionLabel: 'Try again',
                onAction: st.refresh,
              );
            }
            if (st.companies.isEmpty) {
              return _MessageState(
                icon: Icons.apartment_outlined,
                title: 'No companies yet',
                subtitle: 'Create your first company to get started.',
                actionLabel: 'Add company',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateCompanyScreen(),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: st.companies.length,
              itemBuilder: (_, i) {
                final c = st.companies[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16), // spacing between cards
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.apartment, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.registrationNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (c.services.isEmpty)
                          Text(
                            'No services yet',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: c.services.map((s) {
                              return Tooltip(
                                message: s.description,
                                child: Chip(
                                  label: Text(
                                    '${s.name} • RM ${s.price.toStringAsFixed(2)}',
                                  ),
                                  backgroundColor: Colors.blue[50],
                                  labelStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: _FabRail(),
    );
  }
}

class _FabRail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: 'createCompany',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateCompanyScreen()),
          ),
          icon: const Icon(Icons.add_business),
          label: const Text('Add Company'),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: 'createService',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateServiceScreen()),
          ),
          icon: const Icon(Icons.design_services),
          label: const Text('Add Service'),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final Future<void> Function()? onAction;
  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(subtitle, textAlign: TextAlign.center),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 20),
          Center(
            child: FilledButton.tonal(
              onPressed: () => onAction!(),
              child: Text(actionLabel!),
            ),
          ),
        ],
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.black12.withOpacity(.04),
              Colors.black12.withOpacity(.08),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}
