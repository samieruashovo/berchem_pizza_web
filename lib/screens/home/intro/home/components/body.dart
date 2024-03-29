import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../languages/language_constants.dart';

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
           translation(context).takewayDeliveryText.toUpperCase(),
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            translation(context).bestOnlineSellerText,
            style: TextStyle(
              fontSize: 21,
              color: kTextColor.withOpacity(0.34),
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
                    padding: const EdgeInsets.all(10),
                    height: 38,
                    width: 38,
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF372930),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                   translation(context).getStartedText.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
