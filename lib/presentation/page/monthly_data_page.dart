import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/page/monthly_data_list.dart';
import 'package:posrem_webapp/presentation/provider/detailuser_provider.dart';
import 'package:provider/provider.dart';

class MonthlyDataPage extends StatelessWidget {
  final String userId;
  final String year;

  const MonthlyDataPage({super.key, required this.userId, required this.year});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = DetailuserProvider();
        provider.fetchDetailUser(userId).then((_) {
          provider.fetchMonthlyWeightData(userId, year);
        });
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monthly Data for $year'),
        ),
        body: Consumer<DetailuserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.usersDetails == null) {
              return const Center(child: Text('No data available.'));
            } else {
              // Map<int, String> monthMap = {
              //   1: "Jan",
              //   2: "Feb",
              //   3: "Mar",
              //   4: "Apr",
              //   5: "May",
              //   6: "Jun",
              //   7: "Jul",
              //   8: "Aug",
              //   9: "Sep",
              //   10: "Oct",
              //   11: "Nov",
              //   12: "Dec"
              // };

              // List<MapEntry<String, Map<String, dynamic>>> sortedEntries =
              //     provider.weightDataByMonth.entries.toList()
              //       ..sort(
              //           (a, b) => int.parse(a.key).compareTo(int.parse(b.key)));

              final data = provider.usersDetails!;
              final yearData = data['data'][year] ?? {};
              if (yearData.isEmpty) {
                return const Center(
                    child: Text('No monthly data available for this year.'));
              }

              List<String> sortedMonthKeys = yearData.keys.toList()
                ..sort((a, b) {
                  Timestamp createdAtA = yearData[a]['createdAt'];
                  Timestamp createdAtB = yearData[b]['createdAt'];
                  return createdAtA.compareTo(createdAtB);
                });

              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthlyDataList(
                        sortedMonthKeys: sortedMonthKeys,
                        yearData: yearData,
                        userId: userId,
                        year: year,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
