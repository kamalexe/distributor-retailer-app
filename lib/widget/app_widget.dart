import 'package:distributor_retailer_app/models/distributor.dart';
import 'package:flutter/material.dart';

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
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
          backgroundColor: isActive ? Colors.black : Colors.grey.shade200,
          foregroundColor: isActive ? Colors.white : Colors.black,
        ),
        child: Text(text),
      ),
    );

    // return Expanded(
    //   child: InkWell(
    //     onTap: onTap,
    //     child: Container(
    //       alignment: Alignment.center,
    //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    //       decoration: BoxDecoration(color: isActive ? Colors.black : Colors.grey.shade200),
    //       child: Text(
    //         text,
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black),
    //       ),
    //     ),
    //   ),
    // );
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
