import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/components/button_navigation_components.dart';
import 'package:posrem_webapp/presentation/components/top_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              TopBanner(),
              ButtonNavComponents()
            ],
          ),
        ),
      ),
    );
  }
}

