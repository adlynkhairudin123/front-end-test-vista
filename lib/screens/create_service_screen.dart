import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import '../models.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  CompanyModel? _company;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final List<CompanyModel> companies = st.companies;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Service')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<CompanyModel>(
                value: _company,
                items: companies
                    .map<DropdownMenuItem<CompanyModel>>(
                      (c) => DropdownMenuItem<CompanyModel>(
                        value: c,
                        child: Text('${c.name} (${c.registrationNumber})'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _company = v),
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (v) => v == null ? 'Select a company' : null,
              ),
              const SizedBox(height: 20), // spacing

              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Service name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20), // spacing

              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20), // spacing

              TextFormField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final d = double.tryParse(v);
                  if (d == null || d <= 0) return 'Enter a positive number';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              if (st.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(st.error!, style: const TextStyle(color: Colors.red)),
                ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting
                      ? null
                      : () async {
                          if (!_form.currentState!.validate()) return;
                          final price = double.parse(_price.text.trim());
                          setState(() => _submitting = true);
                          final ok = await context.read<AppState>().createService(
                                _name.text.trim(),
                                _desc.text.trim(),
                                price,
                                _company!.id,
                              );
                          setState(() => _submitting = false);
                          if (ok && mounted) Navigator.pop(context);
                        },
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
