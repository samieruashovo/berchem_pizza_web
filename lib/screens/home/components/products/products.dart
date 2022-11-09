import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class Products extends StatelessWidget {
  const Products({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);
  final Product product;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding / 2),
      child: InkWell(
        onTap: press,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  // child: Image.asset(
                  //   product.image,
                  // ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // AutoSizeText(
                //   product.title,
                //   maxLines: 2,
                //   minFontSize: 14,
                //   style: TextStyle(
                //     fontSize: 15,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
