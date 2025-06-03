import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/distributor.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  late Future<List<Distributor>> distributors;
  late TabController tabController;

  List<Distributor> allDistributors = [];
  List<Distributor> filteredDistributors = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      setState(() {});
    });

    distributors = apiService.fetchDistributors();
    distributors.then((list) {
      setState(() {
        allDistributors = list;
        filteredDistributors = list;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void filterSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        filteredDistributors = List.from(allDistributors);
      });
      return;
    }

    final results = allDistributors.where((dist) {
      final name = dist.name.toLowerCase();
      final business = dist.businessName.toLowerCase();
      return name.contains(query.toLowerCase()) || business.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDistributors = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DISTRIBUTOR/RETAILER LIST', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              '(Beta Test)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.pink),
            ),
          ],
        ),
        actions: [
          AppTextButton(text: 'Async', onPressed: () {}),
          SizedBox(width: 12),
          AppIconButton(onPressed: () {}, icon: Icons.filter_list),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        spacing: 12,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: searchFocusNode,
                        controller: searchController,
                        onChanged: filterSearch,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2), borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (searchFocusNode.hasFocus) {
                          searchFocusNode.unfocus();
                        } else {
                          searchFocusNode.requestFocus();
                        }
                        if (searchController.text.isNotEmpty) {
                          filterSearch(searchController.text);
                          searchController.clear();
                          searchFocusNode.unfocus();
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabButton(
                  text: 'DISTRIBUTOR',
                  isActive: tabController.index == 0,
                  onTap: () {
                    tabController.animateTo(0);
                    setState(() {
                      filteredDistributors = List.from(allDistributors);
                    });
                  },
                ),
                TabButton(
                  text: 'RETAILER',
                  isActive: tabController.index == 1,
                  onTap: () {
                    tabController.animateTo(1);
                    setState(() {
                      filteredDistributors = List.from(allDistributors);
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Distributor>>(
              future: distributors,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && allDistributors.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (filteredDistributors.isEmpty) {
                  return const Center(child: Text('No distributors found.'));
                }
                // Tab View
                final distributors = filteredDistributors.where((dist) => dist.type == 'Distributor').toList();
                final retailers = filteredDistributors.where((dist) => dist.type == 'retailer').toList();
                return TabBarView(
                  controller: tabController,
                  children: [
                    ListView.builder(
                      itemCount: distributors.length,
                      itemBuilder: (context, index) {
                        final distributor = distributors[index];
                        return DistributorListTile(distributor: distributor);
                      },
                    ),
                    ListView.builder(
                      itemCount: retailers.length,
                      itemBuilder: (context, index) {
                        final retailer = retailers[index];
                        return DistributorListTile(distributor: retailer);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DistributorListTile extends StatelessWidget {
  final Distributor distributor;
  const DistributorListTile({super.key, required this.distributor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(distributor.businessName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.location_on, size: 16),
                        Text(distributor.address, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Status: ', style: const TextStyle(fontSize: 12)),
                        Text(
                          distributor.isDeleted ? 'Deleted' : 'Active',
                          style: TextStyle(fontSize: 12, color: distributor.isDeleted ? Colors.red : Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final Function() onTap;
  const TabButton({super.key, required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: isActive ? Colors.black : Colors.grey.shade200),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const AppTextButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;
  const AppIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: IconButton(
        highlightColor: Colors.transparent,
        enableFeedback: false,
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, size: 20),
      ),
    );
  }
}
