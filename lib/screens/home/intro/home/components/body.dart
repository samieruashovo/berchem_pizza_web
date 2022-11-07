import 'package:flutter/material.dart';

import '../../cons.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Takeway & Delivery".toUpperCase(),
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: kTextcolor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            "Best online seller",
            style: TextStyle(
              fontSize: 21,
              color: kTextcolor.withOpacity(0.34),
            ),
          ),
          FittedBox(
            // Now it just take the required spaces
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF372930),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF372930),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Get Started".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
