import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/components/button_create_user.dart';
import 'package:posrem_webapp/data/controller/input_controller.dart';

class AddMonthlyData extends StatelessWidget {
  const AddMonthlyData({
    super.key,
    this.id,
  });

  final dynamic id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Monthly Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 500,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                controller: tbController,
                decoration: const InputDecoration(
                  label: Text('Tinggi Badan'),
                ),
              ),
              TextFormField(
                controller: bbController,
                decoration: const InputDecoration(
                  label: Text('Berat Badan'),
                ),
              ),
              TextFormField(
                controller: tdController,
                decoration: const InputDecoration(
                  label: Text('Tekanan Darah'),
                ),
              ),
              TextFormField(
                controller: lilaController,
                decoration: const InputDecoration(
                  label: Text('Lingkar Lengan'),
                ),
              ),
              TextFormField(
                controller: lpController,
                decoration: const InputDecoration(
                  label: Text('Lingkar Perut'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              submitMonthlyData(context, id),
            ],
          ),
        ),
      ),
    );
  }
}