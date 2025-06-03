import 'package:distributor_retailer_app/widget/app_widget.dart';
import 'package:distributor_retailer_app/widget/label_field.dart';
import 'package:flutter/material.dart';

class AddDistributorRetailerPage extends StatefulWidget {
  const AddDistributorRetailerPage({super.key});

  @override
  State<AddDistributorRetailerPage> createState() => _AddDistributorRetailerPageState();
}

class _AddDistributorRetailerPageState extends State<AddDistributorRetailerPage> {
  String selectedType = 'DISTRIBUTOR';
  final _formKey = GlobalKey<FormState>();

  // Dropdown state variables
  String? selectedBrand;
  String? selectedState;
  String? selectedCity;
  String? selectedRegion;
  String? selectedArea;
  String? selectedBank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text("ADD NEW DISTRIBUTOR/RETAILER"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Toggle Distributor / Retailer
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    text: 'DISTRIBUTOR',
                    isActive: selectedType == 'DISTRIBUTOR',
                    onTap: () => setState(() => selectedType = 'DISTRIBUTOR'),
                  ),
                  TabButton(text: 'RETAILER', isActive: selectedType == 'RETAILER', onTap: () => setState(() => selectedType = 'RETAILER')),
                ],
              ),
              const SizedBox(height: 16),

              // Take Photo placeholder
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: Text("Take Photo")),
              ),
              const SizedBox(height: 16),

              // Form Fields
              LabelTextField(
                label: "Distributor Business Name",
                controller: TextEditingController(),
                validator: (value) {
                  if (selectedType == 'DISTRIBUTOR') {
                    return 'Distributor Business Name is required';
                  }
                  return null;
                },
              ),
              LabelTextField(
                label: "Business Type",
                controller: TextEditingController(),
                validator: (value) {
                  if (selectedType == 'DISTRIBUTOR') {
                    return 'Business Type is required';
                  }
                  return null;
                },
              ),

              LabelDropdown(
                label: "Select Brand",
                items: ["Brand A", "Brand B", "Brand C"],
                value: selectedBrand,
                onChanged: (value) {
                  setState(() => selectedBrand = value);
                },
              ),

              LabelTextField(
                label: "Address",
                controller: TextEditingController(),
                validator: (value) {
                  if (selectedType == 'DISTRIBUTOR') {
                    return 'Address is required';
                  }
                  return null;
                },
              ),

              rowDropdown(
                "State",
                ["UP", "MP", "Delhi"],
                selectedState,
                (val) => setState(() => selectedState = val),
                "City",
                ["Varanasi", "Lucknow", "Noida"],
                selectedCity,
                (val) => setState(() => selectedCity = val),
              ),

              rowDropdown(
                "Region",
                ["East", "West"],
                selectedRegion,
                (val) => setState(() => selectedRegion = val),
                "Area",
                ["Zone 1", "Zone 2"],
                selectedArea,
                (val) => setState(() => selectedArea = val),
              ),

              LabelDropdown(
                label: "Bank Name",
                items: ["SBI", "HDFC", "ICICI"],
                value: selectedBank,
                onChanged: (value) {
                  setState(() => selectedBank = value);
                },
              ),

              LabelTextField(
                label: "Gst No.",
                controller: TextEditingController(),
                validator: (value) {
                  if (selectedType == 'DISTRIBUTOR') {
                    return 'Gst No. is required';
                  }
                  return null;
                },
              ),
              LabelTextField(
                label: "Pin code",
                controller: TextEditingController(),
                validator: (value) {
                  if (selectedType == 'DISTRIBUTOR') {
                    return 'Pin code is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // submit logic
                        }
                      },
                      // style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.black),
                      child: const Text("SUBMIT"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Row Dropdown Widget
  Widget rowDropdown(
    String label1,
    List<String> items1,
    String? value1,
    void Function(String?) onChanged1,
    String label2,
    List<String> items2,
    String? value2,
    void Function(String?) onChanged2,
  ) {
    return Row(
      children: [
        Expanded(
          child: LabelDropdown(label: label1, items: items1, value: value1, onChanged: onChanged1),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LabelDropdown(label: label2, items: items2, value: value2, onChanged: onChanged2),
        ),
      ],
    );
  }
}
