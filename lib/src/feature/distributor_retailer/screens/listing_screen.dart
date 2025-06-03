import 'package:distributor_retailer_app/src/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'form_screen.dart';
import '../data/models/user_model.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});
  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  List<UserModel> users = [];
  String searchQuery = '';
  String selectedType = 'Distributor';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final result = await ApiService.fetchUsers(selectedType);
    setState(() {
      users = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) => user.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distributors & Retailers'),
        actions: [
          DropdownButton<String>(
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value!;
                _fetchUsers();
              });
            },
            items: const [
              DropdownMenuItem(value: 'Distributor', child: Text('Distributor')),
              DropdownMenuItem(value: 'Retailer', child: Text('Retailer')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: 'Search by Name'),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (_, index) {
                final user = filteredUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.type),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FormScreen(user: user))),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen())),
      ),
    );
  }
}
