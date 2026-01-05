import 'package:flutter/material.dart';
import 'package:steady/theme/appColor.dart';

class ShowQuoteDialogue extends StatelessWidget {
  const ShowQuoteDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -0.6),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: AppColors.getBackground(context),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
            bottom: Radius.circular(10),
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Daily Quotes",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.getPrimary(context)),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
