import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _reg = TextEditingController();
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Company')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20), 
              TextFormField(
                controller: _reg,
                decoration: const InputDecoration(labelText: 'Registration Number'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                          setState(() => _submitting = true);
                          final ok = await context.read<AppState>().createCompany(
                                _name.text.trim(),
                                _reg.text.trim(),
                              );
                          setState(() => _submitting = false);
                          if (ok && mounted) Navigator.pop(context);
                        },
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
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
