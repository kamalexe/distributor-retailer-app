import 'package:distributor_retailer_app/screens/distributor_retailer_form.dart';
import 'package:distributor_retailer_app/widget/app_widget.dart';
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
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  List<Distributor> allDistributors = [];

  List<Distributor> filteredDistributors = [];
  FocusNode searchFocusNode = FocusNode();

  // Pagination variables
  static const int itemsPerPage = 10;
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreData = true;
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      setState(() {
        // Reset pagination when tab changes
        currentPage = 1;
        allDistributors = [];
        filteredDistributors = [];
        hasMoreData = true;
        loadMoreData();
      });
    });

    // Initial data load
    loadMoreData();
  }

  Future<void> loadMoreData() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      final type = tabController.index == 0 ? 'Distributor' : 'Retailer';
      final newData = await apiService.fetchDistributors(page: currentPage, limit: itemsPerPage, type: type, search: searchQuery);

      setState(() {
        if (newData.isEmpty) {
          hasMoreData = false;
        } else {
          allDistributors.addAll(newData);
          filteredDistributors = List.from(allDistributors);
          currentPage++;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasMoreData = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                setState(() {
                  currentPage = 1;
                  allDistributors = [];
                  filteredDistributors = [];
                  hasMoreData = true;
                });
                loadMoreData();
              },
            ),
          ),
        );
      }
    }
  }

  void filterSearch(String query) {
    setState(() {
      searchQuery = query.trim().isEmpty ? null : query;
      currentPage = 1;
      allDistributors = [];
      filteredDistributors = [];
      hasMoreData = true;
      loadMoreData();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
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
                        controller: searchController,
                        focusNode: searchFocusNode,
                        onSubmitted: filterSearch,
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
                        }
                        filterSearch(searchController.text);
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
            child: TabBarView(controller: tabController, children: [_buildDistributorList(), _buildRetailerList()]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DistributorRetailerForm()));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(Icons.home, 0),
            _buildNavIcon(Icons.camera_alt, 1),
            _buildNavIcon(Icons.storefront, 2),
            _buildNavIcon(Icons.local_offer, 3),
            const SizedBox(width: 40), // space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: index == 2 ? Colors.black : Colors.white),
      child: Icon(icon, color: index == 2 ? Colors.white : Colors.black),
    );
  }

  Widget _buildDistributorList() {
    if (allDistributors.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (allDistributors.isEmpty && !isLoading) {
      return const Center(child: Text('No distributors found.'));
    }

    final distributors = allDistributors.where((element) => element.type == 'Distributor').toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          loadMoreData();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: distributors.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == distributors.length) {
            return const Center(
              child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
            );
          }
          return DistributorListTile(distributor: distributors[index]);
        },
      ),
    );
  }

  Widget _buildRetailerList() {
    if (allDistributors.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (allDistributors.isEmpty && !isLoading) {
      return const Center(child: Text('No retailers found.'));
    }

    final retailers = allDistributors.where((element) => element.type == 'Retailer').toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          loadMoreData();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: retailers.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == retailers.length) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return DistributorListTile(distributor: retailers[index]);
        },
      ),
    );
  }
}
