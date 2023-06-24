import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headertext;
  final String discriptiontext;
  const FeatureBox(
      {super.key,
      required this.color,
      required this.headertext,
      required this.discriptiontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15)).copyWith(
          bottomLeft: Radius.zero,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20 , bottom: 20, left: 15, right: 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                headertext,
                style: TextStyle(
                  fontFamily: 'Cera pro',
                  fontSize: 15,
                  color: Pallete.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              discriptiontext,
              style: TextStyle(
                fontFamily: 'Cera pro',
                color: Pallete.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
