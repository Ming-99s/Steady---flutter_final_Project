import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:steady/theme/appColor.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar-like section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.secondary, // background like appbar
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(169, 73, 72, 72),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 30), // shadow downwards
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Habits',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.border,
                        border: Border.all(color: AppColors.offNav, width: 0.5),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            LineAwesomeIcons.cocktail_solid,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Tokens: ',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          Text(
                            '3/5',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Text('Low energy is okay. Start small today.', style: TextStyle(color: AppColors.primary),)
              ],
            ),
          ),

          // The rest of the home screen content
          Expanded(
            child: Container(
              color: AppColors.background,
              // child: ListView.builder(
              //   itemBuilder: itemBuilder
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
