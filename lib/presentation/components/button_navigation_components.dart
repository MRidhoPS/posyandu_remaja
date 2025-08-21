import 'package:flutter/material.dart';
import 'package:posrem_webapp/presentation/components/widget_list.dart';
import 'package:posrem_webapp/presentation/page/add_user.dart';
import 'package:posrem_webapp/presentation/page/report_data.dart';

class ButtonNavComponents extends StatelessWidget {
  const ButtonNavComponents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonNavigation(
                targetScreen: AddUser(),
                icons: Icons.person_2_rounded,
                text: "Create Users",
              ),
              ButtonNavigation(
                targetScreen: DataUsers(),
                icons: Icons.data_object_rounded,
                text: "Add Monthly Data",
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
         ButtonNavigation(
            targetScreen: ReportData(),
            icons: Icons.data_object_rounded,
            text: "Report Data",
          ),
        ],
      ),
    );
  }
}

class ButtonNavigation extends StatelessWidget {
  const ButtonNavigation({
    super.key,
    required this.icons,
    required this.text,
    required this.targetScreen,
  });

  final Widget targetScreen;
  final IconData icons;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => targetScreen,
        ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(2, 3))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icons,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
