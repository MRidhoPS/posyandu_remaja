import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/page/monthly_data_page.dart';
import 'package:posrem_webapp/presentation/provider/detailuser_provider.dart';

class AvailableYearsSection extends StatelessWidget {
  const AvailableYearsSection(
      {super.key, required this.provider, required this.userId});

  final DetailuserProvider provider;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return provider.availableYears.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Years:',
                style: TextStyle(fontSize: 14, color: Color(0xFF4B4B4B)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.availableYears.length,
                itemBuilder: (context, index) {
                  String year = provider.availableYears[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: ListTile(
                      splashColor: Colors.white,
                      tileColor: Colors.white,
                      title: Text(year, style: const TextStyle(fontSize: 18)),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MonthlyDataPage(userId: userId, year: year),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
