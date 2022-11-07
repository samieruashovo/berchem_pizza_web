import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'cons.dart' as c;

class Prod extends StatelessWidget {
  const Prod({
    Key? key,
    this.imageLink,
    required this.addToCart,
    required this.removeFromCart,
    required this.productTitle,
    required this.productDesc,
  }) : super(key: key);
  final VoidCallback addToCart;
  final VoidCallback removeFromCart;
  final productTitle;
  final productDesc;
  final imageLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding / 2),
      child: Material(
        elevation: 2,
        //borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.none,
                  decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(imageLink))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AutoSizeText(
                productTitle,
                maxLines: 2,
                minFontSize: 14,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              AutoSizeText(
                "sdjs",
                maxLines: 2,
                minFontSize: 14,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: CustomButtonOne(
                          text: const Text("Add to Cart"), press: addToCart)),
                  Flexible(
                      child: CustomButtonOne(
                          text: const Icon(
                            Icons.delete,
                            size: 17,
                          ),
                          press: removeFromCart)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconButto extends StatelessWidget {
  final icon;
  final onPressed;
  final color;
  const IconButto({super.key, this.icon, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}

class CustomButtonOne extends StatelessWidget {
  final text;
  final Function()? press;
  const CustomButtonOne({
    super.key,
    required this.text,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ElevatedButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            backgroundColor: c.kPrimaryColor,
          ),
          onPressed: press,
          child: text),
    );
  }
}
