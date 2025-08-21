import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/components/available_years.dart';
import 'package:posrem_webapp/presentation/components/widget_user.dart';
import 'package:posrem_webapp/presentation/page/add_monthlydata_user.dart';
import 'package:posrem_webapp/presentation/provider/detailuser_provider.dart';
import 'package:provider/provider.dart';

class DetailUser extends StatelessWidget {
  const DetailUser({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailuserProvider()..fetchDetailUser(userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
        ),
        body: Consumer<DetailuserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.usersDetails == null) {
              return const Center(child: Text('No data available.'));
            } else {
              final data = provider.usersDetails!;

              List<Map<String, dynamic>> monthlyData = [];
              if (data['data'] != null) {
                Map<String, dynamic> dataEntries = data['data'];
                dataEntries.forEach((key, value) {
                  var entry = value as Map<String, dynamic>;
                  monthlyData.add(entry);
                });
                monthlyData.sort((a, b) {
                  DateTime dateA = a['createdAt'].toDate();
                  DateTime dateB = b['createdAt'].toDate();
                  return dateA.compareTo(dateB);
                });
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetUsers(data: data, title: 'Name', type: 'name'),
                      WidgetUsers(data: data, title: 'Gender', type: 'gender'),
                      WidgetUsers(data: data, title: 'Born', type: 'born'),
                      WidgetUsers(
                          data: data, title: 'Religion', type: 'religion'),
                      WidgetUsers(
                          data: data, title: 'Address', type: 'address'),
                      WidgetUsers(
                          data: data, title: 'Education', type: 'education'),
                      WidgetUsers(
                          data: data, title: 'Phone Number', type: 'phoneNum'),
                      const SizedBox(height: 15),
                      AvailableYearsSection(provider: provider, userId: userId)
                    ],
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => AddMonthlyData(id: userId),
            ))
                .then((_) {
              if (context.mounted) {
                context.read<DetailuserProvider>().fetchDetailUser(userId);
              }
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
