import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/provider/detailuser_provider.dart';
import 'package:posrem_webapp/util/app_util.dart';
import 'package:provider/provider.dart';

class MonthlyDetailPage extends StatelessWidget {
  final String userId;
  final String year;
  final String month;
  final String monthName;
  final String bmiDesc;

  const MonthlyDetailPage({
    super.key,
    required this.userId,
    required this.year,
    required this.month,
    required this.monthName,
    required this.bmiDesc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final provider = DetailuserProvider();
          provider.fetchDetailUser(userId).then((_) {
            provider.fetchMonthlyWeightData(userId, year);
          });
          return provider;
        }),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<DetailuserProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.usersDetails == null) {
              return const Center(child: Text('No data available.'));
            } else {
              final data = provider.usersDetails!;
              final yearData = data['data'][year] ?? {};
              if (yearData.isEmpty || !yearData.containsKey(month)) {
                return const Center(
                    child: Text('No data available for this month.'));
              }

              final monthData = yearData[month];
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: contentDetailDataMonthly(monthData, context),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Column contentDetailDataMonthly(monthData, BuildContext context) {
    return Column(
      children: [
        _buildBmiCard(monthData),
        _buildDetailCard(monthData, 'Berat Badan', 'bb', 'kg'),
        _buildDetailCard(monthData, 'Tinggi Badan (Height)', 'tb', 'cm'),
        _buildMeasurementRow(monthData, context),
        const SizedBox(height: 20),
        _buildDetailCard(
            monthData, 'Tekanan Darah (Blood Pressure)', 'td', 'mmHg'),
      ],
    );
  }

  Widget _buildBmiCard(Map<String, dynamic> monthData) {
    final bmiColor = monthData['bmiDesc'] == 'Healthy'
        ? const Color(0xFF4B4B4B)
        : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      width: AppUtil.screenWidth,
      height: AppUtil.screenHeight * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your Body', style: TextStyle(fontSize: 20, color: bmiColor)),
          const SizedBox(height: 15),
          Text('${monthData['bmi']}',
              style: TextStyle(
                  fontSize: 80, fontWeight: FontWeight.bold, color: bmiColor)),
          Text('${monthData['bmiDesc']}',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w600, color: bmiColor)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> monthData, String title,
      String dataKey, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      margin: const EdgeInsets.only(bottom: 20),
      width: AppUtil.screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xFF4B4B4B))),
          Text('${monthData[dataKey]} $unit',
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B4B4B),
                  fontSize: 28)),
        ],
      ),
    );
  }

  Widget _buildMeasurementRow(
      Map<String, dynamic> monthData, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMeasurementCard(
            'Lingkar Lengan', '${monthData['lila']} cm', context),
        _buildMeasurementCard(
            'Lingkar Perut', '${monthData['lp']} cm', context),
      ],
    );
  }

  Widget _buildMeasurementCard(
      String label, String value, BuildContext context) {
    return Container(
      width: AppUtil.screenWidth * 0.45,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xFF4B4B4B))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B4B4B),
                  fontSize: 28)),
        ],
      ),
    );
  }
}
