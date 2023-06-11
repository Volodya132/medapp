import 'package:flutter/material.dart';


class AccountInfoWidget extends StatelessWidget {
  var title;
  var textInfo;

  AccountInfoWidget({Key? key, this.title, this.textInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              const Icon(Icons.border_color_rounded),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            child: Text(
              textInfo,
              style:
              const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24),
            ),
          ),
        ],
      );
  }
}
