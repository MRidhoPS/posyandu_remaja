import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posrem_webapp/presentation/page/monthly_detail_page.dart';

class MonthlyDataList extends StatelessWidget {
  final List<String> sortedMonthKeys;
  final Map yearData;
  final String userId;
  final String year;

  const MonthlyDataList(
      {super.key,
      required this.sortedMonthKeys,
      required this.yearData,
      required this.userId,
      required this.year});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        sortedMonthKeys.length,
        (index) {
          String monthKey = sortedMonthKeys[index];
          Map<String, dynamic> monthData = yearData[monthKey];
          Timestamp createdAt = monthData['createdAt'];
          String month = DateFormat('MMMM').format(createdAt.toDate());

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(month, style: const TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MonthlyDetailPage(
                      userId: userId,
                      year: year,
                      month: monthKey,
                      monthName: month,
                      bmiDesc: monthData['bmiDesc'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
