import 'package:distributor_retailer_app/src/core/services/api_service.dart';
import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
class FormScreen extends StatefulWidget {
  final UserModel? user;
  const FormScreen({super.key, this.user});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String type = 'Distributor';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      nameController.text = widget.user!.name;
      type = widget.user!.type;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ApiService.addOrUpdateUser({
        'name': nameController.text,
        'type': type,
        'id': widget.user?.id ?? '', // pass empty for new
        'business_name': 'Test Co.',
        'business_type': 'Test',
        'gst_no': '999XYZ',
        'address': 'Test Address',
        'pincode': '123456',
        'state': 'State',
        'city': 'City',
        'region_id': '1',
        'area_id': '1',
        'user_id': '45',
        'bank_account_id': '2',
        'app_pk': '1',
        'brand_ids': '21,22',
      });

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submission failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user == null ? 'Add' : 'Update')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Person Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'Distributor', child: Text('Distributor')),
                  DropdownMenuItem(value: 'Retailer', child: Text('Retailer')),
                ],
                onChanged: (val) => setState(() => type = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
