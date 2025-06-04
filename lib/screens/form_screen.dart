import 'package:distributor_retailer_app/api/api_service.dart';
import 'package:distributor_retailer_app/constants/api_constants.dart';
import 'package:distributor_retailer_app/models/distributor.dart';
import 'package:distributor_retailer_app/widget/app_widget.dart';
import 'package:distributor_retailer_app/widget/label_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddUpdateDistributorRetailerForm extends StatefulWidget {
  final Distributor? distributor;
  const AddUpdateDistributorRetailerForm({super.key, this.distributor});

  @override
  State<AddUpdateDistributorRetailerForm> createState() => _AddUpdateDistributorRetailerFormState();
}

class _AddUpdateDistributorRetailerFormState extends State<AddUpdateDistributorRetailerForm> {
  final _formKey = GlobalKey<FormState>();

  String selectedType = 'DISTRIBUTOR';
  String? selectedBrand;
  String? selectedState;
  String? selectedCity;
  String? selectedRegion;
  String? selectedArea;
  String? selectedBank;
  XFile? selectedImage;
  // Text controllers
  late TextEditingController businessNameController;
  late TextEditingController businessTypeController;
  late TextEditingController addressController;
  late TextEditingController gstNoController;
  late TextEditingController pinCodeController;

  ApiService apiService = ApiService();

  // Define your value maps

  @override
  void initState() {
    super.initState();

    final d = widget.distributor;

    selectedType = d?.type ?? 'Distributor';

    // Handle brands - take first brand if multiple exist
    selectedBrand = d?.brands.isNotEmpty == true ? d!.brands.first : null;

    selectedState = d?.state;
    selectedCity = d?.city;

    // Validate and set region - only use valid keys from regionMap
    String? regionId = d?.regionId.toString();
    selectedRegion = (regionId != null && regionMap.containsKey(regionId)) ? regionId : null;

    // Validate and set area - only use valid keys from areaMap
    String? areaId = d?.areaId.toString();
    selectedArea = (areaId != null && areaMap.containsKey(areaId)) ? areaId : null;

    // Validate and set bank - only use valid keys from bankMap
    String? bankId = d?.bankAccountId.toString();
    selectedBank = (bankId != null && bankMap.containsKey(bankId)) ? bankId : null;

    businessNameController = TextEditingController(text: d?.businessName ?? '');
    businessTypeController = TextEditingController(text: d?.businessType ?? '');
    addressController = TextEditingController(text: d?.address ?? '');
    gstNoController = TextEditingController(text: d?.gstNo ?? '');
    pinCodeController = TextEditingController(text: d?.pincode ?? '');
  }

  @override
  void dispose() {
    businessNameController.dispose();
    businessTypeController.dispose();
    addressController.dispose();
    gstNoController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  Future<void> addDistributor() async {
    final Map<String, String> formData = {
      "type": selectedType,
      "business_name": businessNameController.text,
      "business_type": businessTypeController.text,
      "brand_ids": selectedBrand ?? "",
      "address": addressController.text,
      "gst_no": gstNoController.text,
      "pincode": pinCodeController.text,
      "state": selectedState ?? "",
      "city": selectedCity ?? "",
      "region_id": selectedRegion ?? "",
      "area_id": selectedArea ?? "",
      "bank_account_id": selectedBank ?? "",
      "user_id": "45",
      "mobile": '9999999999',
      "app_pk": '1',
      "name": businessNameController.text, // Distributor name
      "image": selectedImage?.path ?? "", // Path to the image file
    };

    final res = await apiService.addDistributor(formData);
    if (res) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Distributor added successfully")));
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to add distributor")));
    }
  }
  // ______________

  Future<void> updateDistributor() async {
    final Map<String, String> formData = {
      "type": selectedType, // "Distributor" or "Retailer"
      "business_name": businessNameController.text,
      "business_type": businessTypeController.text,
      "brand_ids": selectedBrand ?? "", // Can be comma-separated if multiple
      "address": addressController.text,
      "gst_no": gstNoController.text,
      "pincode": pinCodeController.text,
      "state": selectedState ?? "",
      "city": selectedCity ?? "",
      "region_id": selectedRegion ?? "",
      "area_id": selectedArea ?? "",
      "bank_account_id": selectedBank ?? "",
      "app_pk": widget.distributor?.appPk.toString() ?? "",
      "id": widget.distributor?.id ?? "", // You may also pass it separately if required
      "user_id": "45",
      "name": widget.distributor?.name ?? "", // Distributor name
      "mobile": widget.distributor?.mobile ?? "",
      "parent_id": widget.distributor?.parentId.toString() ?? "",
      "open_time": widget.distributor?.openTime ?? "",
      "close_time": widget.distributor?.closeTime ?? "",
      "is_approved": widget.distributor?.isApproved.toString() ?? "",
      "image": selectedImage?.path ?? "", // Path to the image file
    };

    final res = await apiService.updateDistributor(formData);
    if (res) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Distributor updated successfully")));
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update distributor")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.distributor != null ? "UPDATE DISTRIBUTOR/RETAILER" : "ADD NEW DISTRIBUTOR/RETAILER"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Toggle Distributor / Retailer
              Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    text: 'DISTRIBUTOR',
                    isActive: selectedType == 'Distributor',
                    onTap: () => setState(() => selectedType = 'Distributor'),
                  ),
                  TabButton(text: 'RETAILER', isActive: selectedType == 'Retailer', onTap: () => setState(() => selectedType = 'Retailer')),
                ],
              ),
              const SizedBox(height: 16),

              // Take Photo placeholder
              ImagePickerWidget(
                initialImage: widget.distributor?.image,
                label: 'Take Photo',
                onImagePicked: (image) {
                  setState(() => selectedImage = image);
                },
              ),

              const SizedBox(height: 16),

              // Form Fields
              LabelTextField(
                label: "Business Name",
                controller: businessNameController,
                validator: (value) => value!.isEmpty ? 'Business Name is required' : null,
              ),
              LabelTextField(
                label: "Business Type",
                controller: businessTypeController,
                validator: (value) => value!.isEmpty ? 'Business Type is required' : null,
              ),

              LabelDropdown(
                label: "Select Brand",
                items: brandMap.keys.toList(),
                value: selectedBrand,
                onChanged: (value) => setState(() => selectedBrand = value),
                valueMap: brandMap,
              ),
              LabelTextField(
                label: "Address",
                controller: addressController,
                validator: (value) => value!.isEmpty ? 'Address is required' : null,
              ),

              // State and City row
              Row(
                children: [
                  Expanded(
                    child: LabelDropdown(
                      label: "State",
                      items: ["UP", "MP", "Delhi"],
                      value: selectedState,
                      onChanged: (val) => setState(() => selectedState = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LabelDropdown(
                      label: "City",
                      items: ["Varanasi", "Lucknow", "Noida"],
                      value: selectedCity,
                      onChanged: (val) => setState(() => selectedCity = val),
                    ),
                  ),
                ],
              ),

              // Region and Area row
              Row(
                children: [
                  Expanded(
                    child: LabelDropdown(
                      label: "Region",
                      items: regionMap.keys.toList(),
                      value: selectedRegion,
                      onChanged: (val) => setState(() => selectedRegion = val),
                      valueMap: regionMap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LabelDropdown(
                      label: "Area",
                      items: areaMap.keys.toList(),
                      value: selectedArea,
                      onChanged: (val) => setState(() => selectedArea = val),
                      valueMap: areaMap,
                    ),
                  ),
                ],
              ),
              LabelDropdown(
                label: "Bank Name",
                items: bankMap.keys.toList(),
                value: selectedBank,
                onChanged: (value) => setState(() => selectedBank = value),
                valueMap: bankMap,
              ),
              LabelTextField(
                label: "Gst No.",
                controller: gstNoController,
                validator: (value) => value!.isEmpty ? 'GST No. is required' : null,
              ),

              LabelTextField(
                label: "Pin code",
                controller: pinCodeController,
                validator: (value) => value!.isEmpty ? 'Pin code is required' : null,
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.distributor != null) {
                            // Submit form
                            updateDistributor();
                          } else {
                            // Submit form
                            addDistributor();
                          }
                        }
                      },
                      child: Text(widget.distributor != null ? "UPDATE" : "ADD"),
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
}
